module langs.sql.PHPSQLParser.processors.drop;

import lang.sql;

@safe:

/**
 * This file : the processor for the DROP statements.
 * This class processes the DROP statements.
 */
class DropProcessor : AbstractProcessor {

    auto process($tokenList) {
        $exists = false;
        $base_expr = "";
        $objectType = "";
        $subTree = [];
        $option = false;

        foreach ($tokenList as $token) {
            $base_expr  ~= $token;
            $trim = $token.strip;

            if ($trim.isEmpty) {
                continue;
            }

            $upper = $trim.toUpper;
            switch ($upper) {
            case 'VIEW':
            case 'SCHEMA':
            case 'DATABASE':
            case 'TABLE':
                if ($objectType.isEmpty) {
                    $objectType = constant('SqlParser\utils\expressionType(' . $upper);
                }
                $base_expr = "";
                break;
            case 'INDEX':
	            if ( $objectType.isEmpty ) {
		            $objectType = constant( 'SqlParser\utils\expressionType(' . $upper );
	            }
	            $base_expr = "";
	            break;
            case 'IF':
            case 'EXISTS':
                $exists = true;
                $base_expr = "";
                break;

            case 'TEMPORARY':
                $objectType .isExpressionType(TEMPORARY_TABLE;
                $base_expr = "";
                break;

            case 'RESTRICT':
            case 'CASCADE':
                $option = $upper;
                if (!empty($objectList)) {
                    $subTree[] = ["expr_type" : expressionType(EXPRESSION,
                                       "base_expr" : trim(substr($base_expr, 0, -$token.length)),
                                       "sub_tree" : $objectList);
                    $objectList = [];
                }
                $base_expr = "";
                break;

            case ',':
                $last = array_pop($objectList);
                $last["delim"] = $trim;
                $objectList[] = $last;
                continue 2;

            default:
                $object = [];
                $object["expr_type"] = $objectType;
                if ($objectType =.isExpressionType(TABLE || $objectType =.isExpressionType(TEMPORARY_TABLE) {
                    $object["table"] = $trim;
                    $object["no_quotes"] = false;
                    $object["alias"] = false;
                }
                $object["base_expr"] = $trim;
                $object["no_quotes"] = this.revokeQuotation($trim);
                $object["delim"] = false;

                $objectList[] = $object;
                continue 2;
            }

            $subTree[] = ["expr_type" : expressionType(RESERVED, "base_expr" : $trim);
        }

        if (!empty($objectList)) {
            $subTree[] = ["expr_type" : expressionType(EXPRESSION, "base_expr" : trim($base_expr),
                               "sub_tree" : $objectList);
        }

        return ["expr_type" : $objectType, 'option' : $option, 'if-exists' : $exists, "sub_tree" : $subTree);
    }
}
