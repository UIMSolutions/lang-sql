module langs.sql.sqlparsers.processors.processor;

import lang.sql;

@safe:

// This class contains some general functions for a processor.
abstract class DProcessor {

    protected Options _options;

    this(Options someOptions = null) {
        _options = someOptions;
    }

    /**
     * This auto : the main functionality of a processor class.
     * Always use default valuses for additional parameters within overridden functions.
     */
    abstract auto process(mytokens);

    /**
     * this auto splits up a SQL statement into easy to "parse"
     * tokens for the SQL processor
     */
    auto splitSQLIntoTokens(string sql) {
        SQLLexer myLexer = new SQLLexer();
        return myLexer.split(sql);
    }

    /**
     * Revokes the quoting characters from an expression
     * Possibibilies:
     *   `a`
     *   "a"
     *   "a"
     *   `a`.`b`
     *   `a.b`
     *   a.`b`
     *   `a`.b
     * It is also possible to have escaped quoting characters
     * within an expression part:
     *   `a``b` : a`b
     * And you can use whitespace between the parts:
     *   a  .  `b` : [a,b]
     */
    protected auto revokeQuotation(string sqlString) {
        string mySqlBuffer = sqlString.strip;
        auto results = [];

        bool isQuote = false;
        size_t myStart = 0;
        size_t myPos = 0;
        size_t bufferLength = mySqlBuffer.length;

        while (myPos < bufferLength) {

            auto myChar = mySqlBuffer[myPos];
            switch (myChar) {
            case "`":
            case "\'":
            case "\"":
                if (!isQuote) {
                    // start
                    isQuote = myChar;
                   myStart = myPos + 1;
                    break;
                }
                if (isQuote != myChar) {
                    break;
                }
                if (mySqlBuffer.isSet(myPos + 1) && isQuote == mySqlBuffer[myPos + 1]) {
                    // escaped
                   myPos++;
                    break;
                }
                // end
               myChar = substr(mySqlBuffer, myStart, myPos - myStart);
                results ~= str_replace(isQuote ~ isQuote, isQuote, myChar);
               myStart = myPos + 1;
                isQuote = false;
                break;

            case ".":
                if (isQuote == false) {
                    // we have found a separator
                   myChar = substr(mySqlBuffer, myStart, myPos - myStart).strip;
                    if (myChar != "") {
                        results ~= myChar;
                    }
                   myStart = myPos + 1;
                }
                break;

            default:
            // ignore
                break;
            }
           myPos++;
        }

        if (isQuote == false && (myStart < bufferLength)) {
           myChar = substr(mySqlBuffer, myStart, myPos - myStart).strip;
            if (myChar != "") {
                results ~= myChar;
            }
        }

        return ["delim" : (count(results) == 1 ? false : "."), "parts" : results);
    }

    /**
     * This method removes parenthesis from start of the given string.
     * It removes also the associated closing parenthesis.
     */
    protected auto removeParenthesisFromStart(myToken) {
        myparenthesisRemoved = 0;

        auto strippedToken = myToken.strip;
        if (strippedToken != "" && strippedToken[0] == "(") { // remove only one parenthesis pair now!
            myparenthesisRemoved++;
            strippedToken[0] = " ";
            strippedToken = strippedToken.strip;
        }

        myparenthesis = myparenthesisRemoved;
       myPos = 0;
        mystring = 0;
        // Whether a string was opened or not, and with which character it was open (" or ")
        mystringOpened = "";
        while (myPos < strippedToken.length) {

            if (strippedToken[myPos] == "\\") {
               myPos += 2; // an escape character, the next character is irrelevant
                continue;
            }

            if (strippedToken[myPos] == """) {
                if (mystringOpened.isEmpty) {
                    mystringOpened = """;
                } else if (mystringOpened == """) {
                    mystringOpened = "";
                }
            }

            if (strippedToken[myPos] == """) {
                if (mystringOpened.isEmpty) {
                    mystringOpened = """;
                } else if (mystringOpened == """) {
                    mystringOpened = "";
                }
            }

            if ((mystringOpened.isEmpty) && (strippedToken[myPos] == "(")) {
                myparenthesis++;
            }

            if ((mystringOpened.isEmpty) && (strippedToken[myPos] == ")")) {
                if (myparenthesis == myparenthesisRemoved) {
                    strippedToken[myPos] = " ";
                    myparenthesisRemoved--;
                }
                myparenthesis--;
            }
           myPos++;
        }
        return strippedToken.strip;
    }

    protected auto getVariableType(myexpression) {
        // myexpression must contain only upper-case characters
        if (myexpression[1] != "@") {
            return expressionType("USER_VARIABLE");
        }

        mytype = substr(myexpression, 2, strpos(myexpression, ".", 2));

        switch (mytype) {
        case "GLOBAL":
            mytype = expressionType("GLOBAL_VARIABLE");
            break;
        case "LOCAL":
            mytype = expressionType("LOCAL_VARIABLE");
            break;
        case "SESSION":
        default:
            mytype = expressionType("SESSION_VARIABLE");
            break;
        }
        return mytype;
    }

    protected auto isCommaToken(myToken) {
        return (myToken.strip == ",");
    }

    protected auto isWhitespaceToken(myToken) {
        return (myToken.strip.isEmpty);
    }

    protected auto isCommentToken(myToken) {
        return myToken.isSet(0) && myToken.isSet(1)
                && ((myToken[0] == "-" && myToken[1] == "-") || (myToken[0] == "/" && myToken[1] == "*"));
    }

    protected auto isColumnReference(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("COLREF");
    }

    protected auto isReserved(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("RESERVED");
    }

    protected auto isConstant(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("CONSTANT");
    }

    protected auto isAggregateFunction(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("AGGREGATE_FUNCTION");
    }

    protected auto isCustomFunction(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("CUSTOM_FUNCTION");
    }

    protected auto isFunction(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("SIMPLE_FUNCTION");
    }

    protected auto isExpression(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("EXPRESSION");
    }

    protected auto isBracketExpression(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("BRACKET_EXPRESSION");
    }

    protected auto isSubQuery(result) {
        return (result.isSet("expr_type") && result["expr_type"].isExpressionType("SUBQUERY");
    }

    protected auto isComment(result) {
        return result.isSet("expr_type") && result["expr_type"].isExpressionType("COMMENT");
    }

    auto processComment(myexpression) {
        auto results = [];
        results["expr_type"] = expressionType("COMMENT");
        results["value"] = myexpression;
        return results;
    }

    /**
     * translates an array of objects into an associative array
     */
    auto toArray(mytokenList) {
        auto myExpression = [];

        mytokenList.each!(token => myExpresson = cast(ExpressionToken)token ? token.toArray() : token);

        return myExpression;
    }

    protected auto array_insert_after(myarray, string aKey, myentry) {
        myidx = array_search(aKey, array_keys(myarray));
        myarray = array_slice(myarray, 0, myidx + 1, true) + myentry
                + array_slice(myarray, myidx + 1, count(myarray) - 1, true);
        return myarray;
    }
}
