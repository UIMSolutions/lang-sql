module langs.sql.PHPSQLParser.processors.with;

import lang.sql;

@safe: 
/**
 * This file : the processor for Oracle's WITH statements.
 * This class processes Oracle's WITH statements.
 */
class WithProcessor : AbstractProcessor {

    protected auto processTopLevel($sql) {
    	auto myProcessor = new DefaultProcessor(this.options);
    	return myProcessor.process($sql);
    }

    protected auto buildTableName($token) {
    	return ["expr_type" : expressionType(TEMPORARY_TABLE, 'name':$token, "base_expr" : $token, 'no_quotes' : this.revokeQuotation($token));
    }

    auto process($tokens) {
    	$out = [];
        $resultList = [];
        $category = "";
        baseExpression = "";
        $prev = "";

        foreach ($token; $tokens) {
        	baseExpression ~= $token;
			auto strippedToken = $token.strip;
            upperToken = strippedToken.toUpper;

            if (this.isWhitespaceToken($token)) {
                continue;
            }

            switch (upperToken) {

            case 'AS':
            	if ($prev != 'TABLENAME') {
            		// error or tablename is AS
            		$resultList[] = this.buildTableName(strippedToken);
            		$category = 'TABLENAME';
            		break;
            	}

            	$resultList[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
            	$category = upperToken;
                break;

            case ",":
            	// ignore
            	baseExpression = "";
            	break;

            default:
                switch ($prev) {
                	case 'AS':
                		// it follows a parentheses pair
                		$subtree = this.processTopLevel(this.removeParenthesisFromStart($token));
                		$resultList[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : strippedToken, "sub_tree" : $subtree);

                		$out[] = ["expr_type" : expressionType(SUBQUERY_FACTORING, "base_expr" : baseExpression.strip, "sub_tree" : $resultList);
                		$resultList = [];
                		$category = "";
                	break;

                	case "":
                		// we have the name of the table
                		$resultList[] = this.buildTableName(strippedToken);
                		$category = 'TABLENAME';
                		break;

                default:
                // ignore
                    break;
                }
                break;
            }
            $prev = $category;
        }
        return $out;
    }
}