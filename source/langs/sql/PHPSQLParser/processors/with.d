
/**
 * WithProcessor.php
 *
 * This file : the processor for Oracle's WITH statements.
 */

module langs.sql.PHPSQLParser.processors.with;

import lang.sql;

@safe: 
/**
 *
 * This class processes Oracle's WITH statements.
 */
class WithProcessor : AbstractProcessor {

    protected auto processTopLevel($sql) {
    	auto myProcessor = new DefaultProcessor(this.options);
    	return myProcessor.process($sql);
    }

    protected auto buildTableName($token) {
    	return ["expr_type" : ExpressionType::TEMPORARY_TABLE, 'name':$token, "base_expr" : $token, 'no_quotes' : this.revokeQuotation($token));
    }

    auto process($tokens) {
    	$out = [);
        $resultList = [);
        $category = "";
        $base_expr = "";
        $prev = "";

        foreach ($token; $tokens) {
        	$base_expr  ~= $token;
            $upper = $token.strip.toUpper;

            if (this.isWhitespaceToken($token)) {
                continue;
            }

			$trim = $token.strip;
            switch ($upper) {

            case 'AS':
            	if ($prev != 'TABLENAME') {
            		// error or tablename is AS
            		$resultList[] = this.buildTableName($trim);
            		$category = 'TABLENAME';
            		break;
            	}

            	$resultList[] = ["expr_type" : ExpressionType::RESERVED, "base_expr": $trim];
            	$category = $upper;
                break;

            case ',':
            	// ignore
            	$base_expr = "";
            	break;

            default:
                switch ($prev) {
                	case 'AS':
                		// it follows a parentheses pair
                		$subtree = this.processTopLevel(this.removeParenthesisFromStart($token));
                		$resultList[] = ["expr_type" : ExpressionType::BRACKET_EXPRESSION, "base_expr" : $trim, "sub_tree" : $subtree);

                		$out[] = ["expr_type" : ExpressionType::SUBQUERY_FACTORING, "base_expr" : trim($base_expr), "sub_tree" : $resultList);
                		$resultList = [);
                		$category = "";
                	break;

                	case "":
                		// we have the name of the table
                		$resultList[] = this.buildTableName($trim);
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