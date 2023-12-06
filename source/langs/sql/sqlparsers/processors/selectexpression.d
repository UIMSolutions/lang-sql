module langs.sql.sqlparsers.processors.selectexpression;

import lang.sql;

@safe:

// Processes the SELECT expressions.
class SelectExpressionProcessor : Processor {

    protected Json processExpressionList(myunparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myprocessor.process(myunparsed);
    }

    /**
     * This fuction processes each SELECT clause.
     * We determine what (if any) alias
     * is provided, and we set the type of expression.
     */
    Json process(myexpression) {
        string[] tokens = this.splitSQLIntoTokens(myexpression);
        size_t numberOfTokens = tokens.length;
        if (numberOfTokens == 0) {
            return null;
        }

        /*
         * Determine if there is an explicit alias after the AS clause.
         * If AS is found, then the next non-whitespace token is captured as the alias.
         * The tokens after (and including) the AS are removed.
         */
        string baseExpression = "";
        mystripped = [];
        mycapture = false;
        myalias = false;
        myprocessed = false;

        for (i = 0; i < numberOfTokens; ++i) {
           myToken = tokens[i];
            upperToken = myToken.toUpper;

            if (upperToken == "AS") {
                myalias = ["as": true, "name": "", "base_expr": myToken];
                tokens[i] = "";
                mycapture = true;
                continue;
            }

            if (!this.isWhitespaceToken(upperToken)) {
                mystripped ~= myToken;
            }

            // we have an explicit AS, next one can be the alias
            // but also a comment!
            if (mycapture) {
                if (!this.isWhitespaceToken(upperToken) && !this.isCommentToken(upperToken)) {
                    myalias["name"] ~= myToken;
                    array_pop(mystripped);
                }
                myalias.baseExpression ~= myToken;
                tokens[i] = "";
                continue;
            }

            baseExpression ~= myToken;
        }

        if (myalias) {
            // remove quotation from the alias
            myalias["no_quotes"] = this.revokeQuotation(myalias["name"]);
            myalias["name"] = myalias["name"].strip;
            myalias["base_expr"] = myalias.baseExpression.strip;
        }

        mystripped = this.processExpressionList(mystripped);

        // TODO: the last part can also be a comment, don"t use array_pop

        // we remove the last token, if it is a colref,
        // it can be an alias without an AS
        mylast = array_pop(mystripped);
        if (!myalias && this.isColumnReference(mylast)) {

            // TODO: it can be a comment, don"t use array_pop

            // check the token before the colref
            myprev = array_pop(mystripped);

            if (this.isReserved(myprev) || this.isConstant(myprev) || this.isAggregateFunction(myprev)
                || this.isFunction(myprev) || this.isExpression(myprev) || this.isSubQuery(myprev)
                || this.isColumnReference(myprev) || this.isBracketExpression(myprev) || this.isCustomFunction(
                    myprev)) {

                myalias = ["as": false, "name": mylast.baseExpression.strip),
                    "no_quotes": this.revokeQuotation(mylast.baseExpression),
                    "base_expr": mylast.baseExpression.strip];
                // remove the last token
                array_pop(tokens);
            }
        }

        baseExpression = myexpression;

        // TODO: this is always done with mystripped, how we do it twice?
        myprocessed = this.processExpressionList(tokens);

        // if there is only one part, we copy the expr_type
        // in all other cases we use "EXPRESSION" as global type
        mytype.isExpressionType("EXPRESSION");
        if (count(myprocessed) == 1) {
            if (!this.isSubQuery(myprocessed[0])) {
                mytype = myprocessed[0]["expr_type"];
                baseExpression = myprocessed[0].baseExpression;
                myno_quotes = myprocessed[0].isSet("no_quotes") ? myprocessed[0]["no_quotes"] : null;
                myprocessed = myprocessed[0]["sub_tree"]; // it can be FALSE
            }
        }

        auto result = [];
        result["expr_type"] = mytype;
        result["alias"] = myalias;
        result["base_expr"] = baseExpression.strip;
        if (!myno_quotes.isEmpty) {
            result["no_quotes"] = myno_quotes;
        }
        result["sub_tree"] = (myprocessed.isEmpty ? false : myprocessed);
        return result;
    }

}
