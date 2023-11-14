
/**
 * AbstractProcessor.php
 *
 * This file : an abstract processor, which : some helper functions.
 *
 *

 *
 */

module lang.sql.parsers.processors;

use SqlParser\lexer\PHPSQLLexer;
use SqlParser\Options;
use SqlParser\utils\ExpressionType;

/**
 * This class contains some general functions for a processor.

 */
abstract class AbstractProcessor {

    /**
     * @var Options
     */
    protected $options;

    /**
     * AbstractProcessor constructor.
     *
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
        $lexer = new PHPSQLLexer();
        return $lexer.split($sql);
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
     *   `a``b` => a`b
     * And you can use whitespace between the parts:
     *   a  .  `b` => [a,b]
     */
    protected auto revokeQuotation($sql) {
        mySqlBuffer = trim($sql);
        $result = array();

        $quote = false;
        $start = 0;
        $i = 0;
        $len = mySqlBuffer.length;

        while ($i < $len) {

            $char = mySqlBuffer[$i];
            switch ($char) {
            case '`':
            case '\'':
            case '"':
                if ($quote == false) {
                    // start
                    $quote = $char;
                    $start = $i + 1;
                    break;
                }
                if ($quote != $char) {
                    break;
                }
                if (isset(mySqlBuffer[$i + 1]) && ($quote == mySqlBuffer[$i + 1])) {
                    // escaped
                    $i++;
                    break;
                }
                // end
                $char = substr(mySqlBuffer, $start, $i - $start);
                $result[] = str_replace($quote . $quote, $quote, $char);
                $start = $i + 1;
                $quote = false;
                break;

            case '.':
                if ($quote == false) {
                    // we have found a separator
                    $char = trim(substr(mySqlBuffer, $start, $i - $start));
                    if ($char != '') {
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

        if ($quote == false && ($start < $len)) {
            $char = trim(substr(mySqlBuffer, $start, $i - $start));
            if ($char != '') {
                $result[] = $char;
            }
        }

        return array('delim' => (count($result) == 1 ? false : '.'), 'parts' => $result);
    }

    /**
     * This method removes parenthesis from start of the given string.
     * It removes also the associated closing parenthesis.
     */
    protected auto removeParenthesisFromStart($token) {
        $parenthesisRemoved = 0;

        $trim = trim($token);
        if ($trim != '' && $trim[0] == '(') { // remove only one parenthesis pair now!
            $parenthesisRemoved++;
            $trim[0] = " ";
            $trim = trim($trim);
        }

        $parenthesis = $parenthesisRemoved;
        $i = 0;
        $string = 0;
        // Whether a string was opened or not, and with which character it was open (' or ")
        $stringOpened = "";
        while ($i < strlen($trim)) {

            if ($trim[$i] == "\\") {
                $i += 2; // an escape character, the next character is irrelevant
                continue;
            }

            if ($trim[$i] == "'") {
                if ($stringOpened == '') {
                    $stringOpened = "'";
                } elseif ($stringOpened == "'") {
                    $stringOpened = "";
                }
            }

            if ($trim[$i] == '"') {
                if ($stringOpened == '') {
                    $stringOpened = '"';
                } elseif ($stringOpened == '"') {
                    $stringOpened = "";
                }
            }

            if (($stringOpened == '') && ($trim[$i] == '(')) {
                $parenthesis++;
            }

            if (($stringOpened == '') && ($trim[$i] == ')')) {
                if ($parenthesis == $parenthesisRemoved) {
                    $trim[$i] = " ";
                    $parenthesisRemoved--;
                }
                $parenthesis--;
            }
            $i++;
        }
        return trim($trim);
    }

    protected auto getVariableType($expression) {
        // $expression must contain only upper-case characters
        if ($expression[1] != '@') {
            return ExpressionType::USER_VARIABLE;
        }

        $type = substr($expression, 2, strpos($expression, '.', 2));

        switch ($type) {
        case 'GLOBAL':
            $type = ExpressionType::GLOBAL_VARIABLE;
            break;
        case 'LOCAL':
            $type = ExpressionType::LOCAL_VARIABLE;
            break;
        case 'SESSION':
        default:
            $type = ExpressionType::SESSION_VARIABLE;
            break;
        }
        return $type;
    }

    protected auto isCommaToken($token) {
        return (trim($token) == ',');
    }

    protected auto isWhitespaceToken($token) {
        return (trim($token) == '');
    }

    protected auto isCommentToken($token) {
        return isset($token[0]) && isset($token[1])
                && (($token[0] == '-' && $token[1] == '-') || ($token[0] == '/' && $token[1] == '*'));
    }

    protected auto isColumnReference($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::COLREF);
    }

    protected auto isReserved($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::RESERVED);
    }

    protected auto isConstant($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::CONSTANT);
    }

    protected auto isAggregateFunction($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::AGGREGATE_FUNCTION);
    }

    protected auto isCustomFunction($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::CUSTOM_FUNCTION);
    }

    protected auto isFunction($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::SIMPLE_FUNCTION);
    }

    protected auto isExpression($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::EXPRESSION);
    }

    protected auto isBracketExpression($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::BRACKET_EXPRESSION);
    }

    protected auto isSubQuery($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::SUBQUERY);
    }

    protected auto isComment($out) {
        return (isset($out["expr_type"]) && $out["expr_type"] == ExpressionType::COMMENT);
    }

    auto processComment($expression) {
        $result = array();
        $result["expr_type"] = ExpressionType::COMMENT;
        $result["value"] = $expression;
        return $result;
    }

    /**
     * translates an array of objects into an associative array
     */
    auto toArray($tokenList) {
        $expr = array();
        foreach ($tokenList as $token) {
            if ($token instanceof \SqlParser\utils\ExpressionToken) {
                $expr[] = $token.toArray();
            } else {
                $expr[] = $token;
            }
        }
        return $expr;
    }

    protected auto array_insert_after($array, $key, $entry) {
        $idx = array_search($key, array_keys($array));
        $array = array_slice($array, 0, $idx + 1, true) + $entry
                + array_slice($array, $idx + 1, count($array) - 1, true);
        return $array;
    }
}
