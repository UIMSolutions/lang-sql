module langs.sql.sqlparsers.processors.with_;

import lang.sql;

@safe: 
// This class processes Oracle"s WITH statements.
class WithProcessor : AbstractProcessor {

    protected auto processTopLevel($sql) {
    	auto myProcessor = new DefaultProcessor(this.options);
    	return myProcessor.process($sql);
    }

    protected string buildTableName(aToken) {
    	return ["expr_type" : expressionType("TEMPORARY_TABLE"), "name":aToken, "base_expr" : aToken, "no_quotes" : this.revokeQuotation(aToken)];
    }

    auto process($tokens) {
    	auto $out = [];
        auto $resultList = [];
        string myCategory = "";
        string baseExpression = "";
        string myPrevious = "";

        foreach (myToken; $tokens) {
        	baseExpression ~= myToken;
			auto strippedToken = myToken.strip;
            upperToken = strippedToken.toUpper;

            if (this.isWhitespaceToken(myToken)) {
                continue;
            }

            switch (upperToken) {

            case "AS":
            	if (myPrevious != "TABLENAME") {
            		// error or tablename is AS
            		$resultList[] = this.buildTableName(strippedToken);
            		myCategory = "TABLENAME";
            		break;
            	}

            	$resultList[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
            	myCategory = upperToken;
                break;

            case ",":
            	// ignore
            	baseExpression = "";
            	break;

            default:
                switch (myPrevious) {
                	case "AS":
                		// it follows a parentheses pair
                		$subtree = this.processTopLevel(this.removeParenthesisFromStart(myToken));
                		$resultList[] = ["expr_type" : expressionType("BRACKET_EXPRESSION"), "base_expr" : strippedToken, "sub_tree" : $subtree];

                		$out[] = ["expr_type" : expressionType("SUBQUERY_FACTORING"), "base_expr" : baseExpression.strip, "sub_tree" : $resultList];
                		$resultList = [];
                		myCategory = "";
                	break;

                	case "":
                		// we have the name of the table
                		$resultList[] = this.buildTableName(strippedToken);
                		myCategory = "TABLENAME";
                		break;

                default:
                // ignore
                    break;
                }
                break;
            }
            myPrevious = myCategory;
        }
        return $out;
    }
}