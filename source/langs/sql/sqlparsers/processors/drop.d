module langs.sql.sqlparsers.processors.drop;

import lang.sql;

@safe:

/**
 * This file : the processor for the DROP statements.
 * This class processes the DROP statements.
 */
class DropProcessor : AbstractProcessor {

    auto process($tokenList) {
        $exists = false;
        string baseExpression = "";
        auto objectType = "";
        $subTree = [];
        $option = false;

        foreach ($tokenList as $token) {
            baseExpression ~= $token;
            strippedToken = $token.strip;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {
            case "VIEW":
            case "SCHEMA":
            case "DATABASE":
            case "TABLE":
                if (objectType.isEmpty) {
                    objectType = constant("SqlParser\utils\expressionType(" . upperToken);
                }
                baseExpression = "";
                break;
            case "INDEX":
	            if ( objectType.isEmpty ) {
		            objectType = constant( "SqlParser\utils\expressionType(" ~ upperToken );
	            }
	            baseExpression = "";
	            break;
            case "IF":
            case "EXISTS":
                $exists = true;
                baseExpression = "";
                break;

            case "TEMPORARY":
                objectType = expressionType("TEMPORARY_TABLE");
                baseExpression = "";
                break;

            case "RESTRICT":
            case "CASCADE":
                $option = upperToken;
                if (!empty($objectList)) {
                    $subTree[] = ["expr_type" : expressionType(EXPRESSION,
                                       "base_expr" : substr(baseExpression, 0, -$token.length).strip,
                                       "sub_tree" : $objectList);
                    $objectList = [];
                }
                baseExpression = "";
                break;

            case ",":
                $last = array_pop($objectList);
                $last["delim"] = strippedToken;
                $objectList[] = $last;
                continue 2;

            default:
                $object = [];
                $object["expr_type"] = objectType;
                if (objectType.isExpressionType("TABLE") || objectType.isExpressionType("TEMPORARY_TABLE")) {
                    $object["table"] = strippedToken;
                    $object["no_quotes"] = false;
                    $object["alias"] = false;
                }
                $object["base_expr"] = strippedToken;
                $object["no_quotes"] = this.revokeQuotation(strippedToken);
                $object["delim"] = false;

                $objectList[] = $object;
                continue 2;
            }

            $subTree[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
        }

        if (!empty($objectList)) {
            $subTree[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : baseExpression.strip,
                               "sub_tree" : $objectList];
        }

        return ["expr_type" : objectType, "option" : $option, "if-exists" : $exists, "sub_tree" : $subTree);
    }
}
