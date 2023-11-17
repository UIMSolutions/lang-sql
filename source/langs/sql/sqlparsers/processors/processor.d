module langs.sql.sqlparsers.processors.processor;

import lang.sql;

@safe:

/**
 * This file : an abstract processor, which : some helper functions.
 * This class contains some general functions for a processor.
 */
abstract class DProcessor {

    /**
     * @var Options
     */
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
    auto splitSQLIntoTokens($sql) {
        auto myLexer = new PHPSQLLexer();
        return myLexer.split($sql);
    }

    /**
     * Revokes the quoting characters from an expression
     * Possibibilies:
     *   `a`
     *   'a'
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
    protected auto revokeQuotation($sql) {
        auto mySqlBuffer = $sql.strip;
        $result = [];

        bool isQuote = false;
        $start = 0;
        $i = 0;
        size_t bufferLength = mySqlBuffer.length;

        while ($i < bufferLength) {

            $char = mySqlBuffer[$i];
            switch ($char) {
            case "`":
            case "\'":
            case "\"":
                if (isQuote == false) {
                    // start
                    isQuote = $char;
                    $start = $i + 1;
                    break;
                }
                if (isQuote != $char) {
                    break;
                }
                if (mySqlBuffer.isSet($i + 1) && isQuote == mySqlBuffer[$i + 1]) {
                    // escaped
                    $i++;
                    break;
                }
                // end
                $char = substr(mySqlBuffer, $start, $i - $start);
                $result[] = str_replace(isQuote ~ isQuote, isQuote, $char);
                $start = $i + 1;
                isQuote = false;
                break;

            case '.':
                if (isQuote == false) {
                    // we have found a separator
                    $char = substr(mySqlBuffer, $start, $i - $start).strip;
                    if ($char != "") {
                        $result[] = $char;
                    }
                    $start = $i + 1;
                }
                break;

            default:
            // ignore
                break;
            }
            $i++;
        }

        if (isQuote == false && ($start < bufferLength)) {
            $char = substr(mySqlBuffer, $start, $i - $start).strip;
            if ($char != "") {
                $result[] = $char;
            }
        }

        return ['delim' : (count($result) == 1 ? false : '.'), 'parts' : $result);
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
        $i = 0;
        $string = 0;
        // Whether a string was opened or not, and with which character it was open (' or ")
        $stringOpened = "";
        while ($i < strippedToken.length) {

            if (strippedToken[$i] == "\\") {
                $i += 2; // an escape character, the next character is irrelevant
                continue;
            }

            if (strippedToken[$i] == "'") {
                if ($stringOpened.isEmpty) {
                    $stringOpened = "'";
                } else if ($stringOpened == "'") {
                    $stringOpened = "";
                }
            }

            if (strippedToken[$i] == '"') {
                if ($stringOpened.isEmpty) {
                    $stringOpened = '"';
                } else if ($stringOpened == '"') {
                    $stringOpened = "";
                }
            }

            if (($stringOpened.isEmpty) && (strippedToken[$i] == "(")) {
                $parenthesis++;
            }

            if (($stringOpened.isEmpty) && (strippedToken[$i] == ")")) {
                if ($parenthesis == $parenthesisRemoved) {
                    strippedToken[$i] = " ";
                    $parenthesisRemoved--;
                }
                $parenthesis--;
            }
            $i++;
        }
        return strippedToken.strip;
    }

    protected auto getVariableType($expression) {
        // $expression must contain only upper-case characters
        if ($expression[1] != '@') {
            return expressionType("USER_VARIABLE");
        }

        $type = substr($expression, 2, strpos($expression, '.', 2));

        switch ($type) {
        case 'GLOBAL':
            $type = expressionType("GLOBAL_VARIABLE");
            break;
        case 'LOCAL':
            $type = expressionType("LOCAL_VARIABLE");
            break;
        case 'SESSION':
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
        return ($out.isSet("expr_type") && $out["expr_type"].isExpressionType("COMMENT");
    }

    auto processComment($expression) {
        $result = [];
        $result["expr_type"] = expressionType("COMMENT");
        $result["value"] = $expression;
        return $result;
    }

    /**
     * translates an array of objects into an associative array
     */
    auto toArray($tokenList) {
        myExpression = [];
        foreach (myToken; $tokenList) {
            if (cast(ExpressionToken)myToken) {
                myExpression[] = myToken.toArray();
            } else {
                myExpression[] = myToken;
            }
        }
        return myExpression;
    }

    protected auto array_insert_after($array, $key, $entry) {
        $idx = array_search($key, array_keys($array));
        $array = array_slice($array, 0, $idx + 1, true) + $entry
                + array_slice($array, $idx + 1, count($array) - 1, true);
        return $array;
    }
}
