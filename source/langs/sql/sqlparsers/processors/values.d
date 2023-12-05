module langs.sql.sqlparsers.processors.values;

import lang.sql;

@safe:

// This class processes the VALUES statements.
class ValuesProcessor : AbstractProcessor {

    auto process(mytokens) {

        string currentCategory = "";
        myparsed = [];
        string baseExpression = "";

        foreach (myKey, myToken; mytokens["VALUES"]) {
	        if (this.isCommentToken(myToken)) {
		        myparsed ~= super.processComment(myToken);
		        continue;
	        }

	        baseExpression ~= myToken;
	        auto strippedToken = myToken.strip;

            if (this.isWhitespaceToken(myToken)) {
                continue;
            }

            string upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case "ON":
                if (currentCategory.isEmpty) {

                    baseExpression = substr(baseExpression, 0, -myToken.length).strip;
                    parsed = createExpression("RECORD", baseExpression);
                    parsed["data"] = this.processRecord(baseExpression);
                    parsed["delim"] = false;
                    baseExpression = "";

                    currentCategory = "DUPLICATE";
                    parsed = createExpression("RESERVED", strippedToken);
                }
                // else ?
                break;

            case "DUPLICATE":
            case "KEY":
            case "UPDATE":
                if (currentCategory == "DUPLICATE") {
                    myparsed ~= createExpression("RESERVED"), "base_expr": strippedToken];
                    baseExpression = "";
                }
                // else ?
                break;

            case ",":
                if (currentCategory == "DUPLICATE") {

                    baseExpression = substr(baseExpression, 0, -strlen(myToken)).strip;
                    myres = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                    myparsed ~= createExpression("EXPRESSION"), "base_expr" : baseExpression,
                                      "sub_tree" : (myres.isEmpty ? false : myres), "delim": strippedToken];
                    baseExpression = "";
                    continue 2;
                }

                myparsed ~= createExpression("RECORD"), "base_expr" : baseExpression.strip,
                                  "data" : this.processRecord(baseExpression.strip), "delim": strippedToken];
                baseExpression = "";
                break;

            default:
                break;
            }

        }

        if (!baseExpression.strip.isEmpty) {
            if (currentCategory.isEmpty) {
                myparsed ~= createExpression("RECORD"), "base_expr" : baseExpression.strip,
                                  "data" : this.processRecord(baseExpression.strip), "delim" : false];
            }
            if (currentCategory == "DUPLICATE") {
                myres = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                myparsed ~= createExpression("EXPRESSION"), "base_expr" : baseExpression.strip,
                                  "sub_tree" : (myres.isEmpty ? false : myres), "delim" : false];
            }
        }

        mytokens["VALUES"] = myparsed;
        return mytokens;
    }

    protected auto processExpressionList(myunparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process(myunparsed);
    }

    protected auto processRecord(myunparsed) {
        auto myProcessor = new RecordProcessor(this.options);
        return myProcessor.process(myunparsed);
    }

}
