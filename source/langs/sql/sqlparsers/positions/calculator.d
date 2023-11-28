module langs.sql.sqlparsers.positions.calculator;

import lang.sql;

@safe:

/**
 *  * This class : the calculator for the string positions of the 
 * base_expr elements within the output of the SqlParser.
 This class : the calculator for the string positions of the 
 * base_expr elements within the output of the SqlParser. */
class PositionCalculator {

    protected static $allowedOnOperator = ["\t", "\n", "\r", " ", ",", "(", ")", "_", """, "\"", "?", "@", "0",
                                                "1", "2", "3", "4", "5", "6", "7", "8", "9");
    protected static $allowedOnOther = ["\t", "\n", "\r", " ", ",", "(", ")", "<", ">", "*", "+", "-", "/", "|",
                                             "&", "=", "!", ";");

    protected $flippedBacktrackingTypes;
    protected static $backtrackingTypes = [expressionType("EXPRESSION"), expressionType("SUBQUERY"),
                                                expressionType("BRACKET_EXPRESSION"), expressionType("TABLE_EXPRESSION"),
                                                expressionType("RECORD"), expressionType("IN_LIST"),
                                                expressionType("MATCH_ARGUMENTS", expressionType("TABLE",
                                                expressionType("TEMPORARY_TABLE", expressionType("COLUMN_TYPE",
                                                expressionType("COLDEF", expressionType("PRIMARY_KEY",
                                                expressionType("CONSTRAINT"), expressionType("COLUMN_LIST"),
                                                expressionType("CHECK", expressionType("COLLATE", expressionType("LIKE",
                                                expressionType("INDEX", expressionType("INDEX_TYPE",
                                                expressionType("INDEX_SIZE", expressionType("INDEX_PARSER",
                                                expressionType("FOREIGN_KEY", expressionType("REFERENCE",
                                                expressionType("PARTITION", expressionType("PARTITION_HASH",
                                                expressionType("PARTITION_COUNT", expressionType("PARTITION_KEY",
                                                expressionType("PARTITION_KEY_ALGORITHM",
                                                expressionType("PARTITION_RANGE", expressionType("PARTITION_LIST",
                                                expressionType("PARTITION_DEF", expressionType("PARTITION_VALUES",
                                                expressionType("SUBPARTITION_DEF", expressionType("PARTITION_DATA_DIR",
                                                expressionType("PARTITION_INDEX_DIR", expressionType("PARTITION_COMMENT",
                                                expressionType("PARTITION_MAX_ROWS", expressionType("PARTITION_MIN_ROWS",
                                                expressionType("SUBPARTITION_COMMENT",
                                                expressionType("SUBPARTITION_DATA_DIR",
                                                expressionType("SUBPARTITION_INDEX_DIR",
                                                expressionType("SUBPARTITION_KEY",
                                                expressionType("SUBPARTITION_KEY_ALGORITHM",
                                                expressionType("SUBPARTITION_MAX_ROWS",
                                                expressionType("SUBPARTITION_MIN_ROWS"), expressionType("SUBPARTITION",
                                                expressionType("SUBPARTITION_HASH", expressionType("SUBPARTITION_COUNT",
                                                expressionType("CHARSET", expressionType("ENGINE", expressionType("QUERY",
                                                expressionType("INDEX_ALGORITHM", expressionType("INDEX_LOCK",
    											expressionType("SUBQUERY_FACTORING"), expressionType("CUSTOM_FUNCTION",
                                                expressionType("SIMPLE_FUNCTION")
    );

    /**
     * Constructor.
     * 
     * It initializes some fields.
     */
    this() {
        this.flippedBacktrackingTypes = array_flip(this.$backtrackingTypes);
    }

    protected auto printPos($text, $sql, $charPos, myKey, $parsed, $backtracking) {
        if (!isset($_SERVER["DEBUG"])) {
            return;
        }

        string mySpaces = "";
        $caller = debug_backtrace();
        $i = 1;
        while ($caller[$i]["function"] == "lookForBaseExpression") {
            mySpaces ~= "   ";
            $i++;
        }
        $holdem = substr($sql, 0, $charPos) . "^" . substr($sql, $charPos);
        echo mySpaces . $text . " key:" . myKey . "  parsed:" . $parsed . " back:" . serialize($backtracking) . " "
            . $holdem . "\n";
    }

    auto setPositionsWithinSQL($sql, $parsed) {
        $charPos = 0;
        $backtracking = [];
        this.lookForBaseExpression($sql, $charPos, $parsed, 0, $backtracking);
        return $parsed;
    }

    protected auto findPositionWithinString($sql, myValue, $expr_type) {
        if (myValue.isEmpty) {
            return false;
        }

        $offset = 0;
        bool isOK = false;
        while (true) {

            $pos = strpos($sql, myValue, $offset);
            // error_log("pos:$pos value:myValue sql:$sql");
            
            if ($pos == false) {
                break;
            }

            $before = "";
            if ($pos > 0) {
                $before = $sql[$pos - 1];
            }

            // if we have a quoted string, we every character is allowed after it
            // see issues 137 and 361
            $quotedBefore = in_array($sql[$pos], ["`", "("), true);
            $quotedAfter = in_array($sql[$pos + strlen(myValue) - 1], ["`", ")"), true);
            $after = "";
            if (isset($sql[$pos + strlen(myValue)])) {
                $after = $sql[$pos + strlen(myValue)];
            }

            // if we have an operator, it should be surrounded by
            // whitespace, comma, parenthesis, digit or letter, end_of_string
            // an operator should not be surrounded by another operator

            if (in_array($expr_type,["operator","column-list"),true)) {

                isOK = ($before.isEmpty || in_array($before, this.$allowedOnOperator, true))
                    || ($before.toLower >= "a" && $before.toLower <= "z");
                isOK = isOK
                    && ($after.isEmpty || in_array($after, this.$allowedOnOperator, true)
                        || ($after.toLower >= "a" && $after.toLower <= "z"));

                if (!isOK) {
                    $offset = $pos + 1;
                    continue;
                }

                break;
            }

            // in all other cases we accept
            // whitespace, comma, operators, parenthesis and end_of_string

            isOK = ($before.isEmpty || in_array($before, this.$allowedOnOther, true)
                || ($quotedBefore && ($before.toLower >= "a" && $before.toLower <= "z")));
            isOK = isOK
                && ($after.isEmpty || in_array($after, this.$allowedOnOther, true)
                    || ($quotedAfter && ($after.toLower >= "a" && $after.toLower <= "z")));

            if (isOK) {
                break;
            }

            $offset = $pos + 1;
        }

        return $pos;
    }

    protected auto lookForBaseExpression($sql, &$charPos, &$parsed, myKey, &$backtracking) {
        if (!is_numeric(myKey)) {
            if ((myKey == "UNION" || myKey == "UNION ALL")
                || (myKey == "expr_type" && isset(this.flippedBacktrackingTypes[$parsed]))
                || (myKey == "select-option" && $parsed != false) || (myKey == "alias" && $parsed != false)) {
                // we hold the current position and come back after the next base_expr
                // we do this, because the next base_expr contains the complete expression/subquery/record
                // and we have to look into it too
                $backtracking[] = $charPos;

            } else if ((myKey == "ref_clause" || myKey == "columns") && $parsed != false) {
                // we hold the current position and come back after n base_expr(s)
                // there is an array of sub-elements before (!) the base_expr clause of the current element
                // so we go through the sub-elements and must come at the end
                $backtracking[] = $charPos;
                for ($i = 1; $i < count($parsed); $i++) {
                    $backtracking[] = false; // backtracking only after n base_expr!
                }
            } else if ((myKey == "sub_tree" && $parsed != false) || (myKey == "options" && $parsed != false)) {
                // we prevent wrong backtracking on subtrees (too much array_pop())
                // there is an array of sub-elements after(!) the base_expr clause of the current element
                // so we go through the sub-elements and must not come back at the end
                for ($i = 1; $i < count($parsed); $i++) {
                    $backtracking[] = false;
                }
            } else if ((myKey == "TABLE") || (myKey == "create-def" && $parsed != false)) {
                // do nothing
            } else {
                // move the current pos after the keyword
                // SELECT, WHERE, INSERT etc.
                if (SqlParserConstants::getInstance().isReserved(myKey)) {
                    $charPos = stripos($sql, myKey, $charPos);
                    $charPos += strlen(myKey);
                }
            }
        }

        if (!is_array($parsed)) {
            return;
        }

        foreach (myKey : myValue; $parsed) {
            if (myKey == "base_expr") {

                //this.printPos("0", $sql, $charPos, myKey, myValue, $backtracking);

                $subject = substr($sql, $charPos);
                $pos = this.findPositionWithinString($subject, myValue,
                    isset($parsed["expr_type"]) ? $parsed["expr_type"] : "alias");
                if ($pos == false) {
                    throw new UnableToCalculatePositionException(myValue, $subject);
                }

                $parsed["position"] = $charPos + $pos;
                $charPos += $pos + strlen(myValue);

                //this.printPos("1", $sql, $charPos, myKey, myValue, $backtracking);

                $oldPos = array_pop($backtracking);
                if (isset($oldPos) && $oldPos != false) {
                    $charPos = $oldPos;
                }

                //this.printPos("2", $sql, $charPos, myKey, myValue, $backtracking);

            } else {
                this.lookForBaseExpression($sql, $charPos, $parsed[myKey], myKey, $backtracking);
            }
        }
    }
}

