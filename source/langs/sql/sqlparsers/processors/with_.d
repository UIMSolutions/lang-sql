module langs.sql.sqlparsers.processors.with_;

import lang.sql;

@safe: 
// This class processes Oracle"s WITH statements.
class WithProcessor : Processor {

    protected Json processTopLevel(mysql) {
    	auto myProcessor = new DefaultProcessor(this.options);
    	return myProcessor.process(mysql);
    }

    protected string buildTableName(aToken) {
    	return createExpression("TEMPORARY_TABLE"), "name":aToken, "base_expr" : aToken, "no_quotes" : this.revokeQuotation(aToken)];
    }

    Json process(mytokens) {
    	auto result = [];
        auto myresultList = [];
        string myCategory = "";
        string baseExpression = "";
        string myPrevious = "";

        foreach (myToken; mytokens) {
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
            		 myresultList ~= this.buildTableName(strippedToken);
            		myCategory = "TABLENAME";
            		break;
            	}

            	 myresultList ~= createExpression("RESERVED", strippedToken];
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
                		 mysubtree = this.processTopLevel(this.removeParenthesisFromStart(myToken));
                		 myresultList ~= createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken, "sub_tree" : mysubtree];

                		result ~= createExpression("SUBQUERY_FACTORING"), "base_expr" : baseExpression.strip, "sub_tree" : myresultList];
                		 myresultList = [];
                		myCategory = "";
                	break;

                	case "":
                		// we have the name of the table
                		 myresultList ~= this.buildTableName(strippedToken);
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
        return result;
    }
}