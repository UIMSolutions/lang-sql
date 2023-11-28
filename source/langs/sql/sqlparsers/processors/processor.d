module langs.sql.sqlparsers.processors.processor;

import lang.sql;

@safe:

// This class contains some general functions for a processor.
abstract class DProcessor {

    protected $options;

    /**
     * @param Options $options
     */
    this(Options $options = null)
    {
        this.options = $options;
    }

    /**
     * This auto : the main functionality of a processor class.
     * Always use default valuses for additional parameters within overridden functions.
     */
    abstract auto process($tokens);

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
                results[] = str_replace(isQuote ~ isQuote, isQuote, myChar);
                myStart = myPos + 1;
                isQuote = false;
                break;

            case ".":
                if (isQuote == false) {
                    // we have found a separator
                    myChar = substr(mySqlBuffer, myStart, myPos - myStart).strip;
                    if (myChar != "") {
                        results[] = myChar;
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
                results[] = myChar;
            }
        }

        return ["delim" : (count(results) == 1 ? false : "."), "parts" : results);
    }

    /**
     * This method removes parenthesis from start of the given string.
     * It removes also the associated closing parenthesis.
     */
    protected auto removeParenthesisFromStart(myToken) {
        $parenthesisRemoved = 0;

        auto strippedToken = myToken.strip;
        if (strippedToken != "" && strippedToken[0] == "(") { // remove only one parenthesis pair now!
            $parenthesisRemoved++;
            strippedToken[0] = " ";
            strippedToken = strippedToken.strip;
        }

        $parenthesis = $parenthesisRemoved;
        myPos = 0;
        $string = 0;
        // Whether a string was opened or not, and with which character it was open (" or ")
        $stringOpened = "";
        while (myPos < strippedToken.length) {

            if (strippedToken[myPos] == "\\") {
                myPos += 2; // an escape character, the next character is irrelevant
                continue;
            }

            if (strippedToken[myPos] == """) {
                if ($stringOpened.isEmpty) {
                    $stringOpened = """;
                } else if ($stringOpened == """) {
                    $stringOpened = "";
                }
            }

            if (strippedToken[myPos] == """) {
                if ($stringOpened.isEmpty) {
                    $stringOpened = """;
                } else if ($stringOpened == """) {
                    $stringOpened = "";
                }
            }

            if (($stringOpened.isEmpty) && (strippedToken[myPos] == "(")) {
                $parenthesis++;
            }

            if (($stringOpened.isEmpty) && (strippedToken[myPos] == ")")) {
                if ($parenthesis == $parenthesisRemoved) {
                    strippedToken[myPos] = " ";
                    $parenthesisRemoved--;
                }
                $parenthesis--;
            }
            myPos++;
        }
        return strippedToken.strip;
    }

    protected auto getVariableType($expression) {
        // $expression must contain only upper-case characters
        if ($expression[1] != "@") {
            return expressionType("USER_VARIABLE");
        }

        $type = substr($expression, 2, strpos($expression, ".", 2));

        switch ($type) {
        case "GLOBAL":
            $type = expressionType("GLOBAL_VARIABLE");
            break;
        case "LOCAL":
            $type = expressionType("LOCAL_VARIABLE");
            break;
        case "SESSION":
        default:
            $type = expressionType("SESSION_VARIABLE");
            break;
        }
        return $type;
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

    protected auto isColumnReference($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("COLREF");
    }

    protected auto isReserved($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("RESERVED");
    }

    protected auto isConstant($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("CONSTANT");
    }

    protected auto isAggregateFunction($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("AGGREGATE_FUNCTION");
    }

    protected auto isCustomFunction($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("CUSTOM_FUNCTION");
    }

    protected auto isFunction($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("SIMPLE_FUNCTION");
    }

    protected auto isExpression($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("EXPRESSION");
    }

    protected auto isBracketExpression($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("BRACKET_EXPRESSION");
    }

    protected auto isSubQuery($out) {
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("SUBQUERY");
    }

    protected auto isComment($out) {
        return $out.isSet("expr_type") && $out["expr_type"].isExpressionType("COMMENT");
    }

    auto processComment($expression) {
        auto results = [];
        results["expr_type"] = expressionType("COMMENT");
        results["value"] = $expression;
        return results;
    }

    /**
     * translates an array of objects into an associative array
     */
    auto toArray($tokenList) {
        auto myExpression = [];

        $tokenList.each!(token => myExpresson = cast(ExpressionToken)token ? token.toArray() : token);

        return myExpression;
    }

    protected auto array_insert_after($array, string aKey, $entry) {
        $idx = array_search(aKey, array_keys($array));
        $array = array_slice($array, 0, $idx + 1, true) + $entry
                + array_slice($array, $idx + 1, count($array) - 1, true);
        return $array;
    }
}
