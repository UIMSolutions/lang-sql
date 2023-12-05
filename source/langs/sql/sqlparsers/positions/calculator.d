module langs.sql.sqlparsers.positions.calculator;

import lang.sql;

@safe:

/**
 *  * This class : the calculator for the string positions of the 
 * base_expr elements within the output of the SqlParser.
 This class : the calculator for the string positions of the 
 * base_expr elements within the output of the SqlParser. */
class PositionCalculator {

    protected static myallowedOnOperator = ["\t", "\n", "\r", " ", ",", "(", ")", "_", """, "\"", "?", "@", "0",
                                                "1", "2", "3", "4", "5", "6", "7", "8", "9");
    protected static myallowedOnOther = ["\t", "\n", "\r", " ", ",", "(", ")", "<", ">", "*", "+", "-", "/", "|",
                                             "&", "=", "!", ";");

    protected myflippedBacktrackingTypes;
    protected static mybacktrackingTypes = [expressionType("EXPRESSION"), expressionType("SUBQUERY"),
                                                expressionType("BRACKET_EXPRESSION"), expressionType("TABLE_EXPRESSION"),
                                                expressionType("RECORD"), expressionType("IN_LIST"),
                                                expressionType("MATCH_ARGUMENTS"), expressionType("TABLE"), 
                                                expressionType("TEMPORARY_TABLE"), expressionType("COLUMN_TYPE"), 
                                                expressionType("COLDEF"), expressionType("PRIMARY_KEY"), 
                                                expressionType("CONSTRAINT"), expressionType("COLUMN_LIST"),
                                                expressionType("CHECK"), expressionType("COLLATE"), expressionType("LIKE"), 
                                                expressionType("INDEX"), expressionType("INDEX_TYPE"), 
                                                expressionType("INDEX_SIZE"), expressionType("INDEX_PARSER"), 
                                                expressionType("FOREIGN_KEY"), expressionType("REFERENCE"), 
                                                expressionType("PARTITION"), expressionType("PARTITION_HASH"), 
                                                expressionType("PARTITION_COUNT"), expressionType("PARTITION_KEY"), 
                                                expressionType("PARTITION_KEY_ALGORITHM"), 
                                                expressionType("PARTITION_RANGE"), expressionType("PARTITION_LIST"), 
                                                expressionType("PARTITION_DEF"), expressionType("PARTITION_VALUES"), 
                                                expressionType("SUBPARTITION_DEF"), expressionType("PARTITION_DATA_DIR"), 
                                                expressionType("PARTITION_INDEX_DIR"), expressionType("PARTITION_COMMENT"), 
                                                expressionType("PARTITION_MAX_ROWS"), expressionType("PARTITION_MIN_ROWS"), 
                                                expressionType("SUBPARTITION_COMMENT"), 
                                                expressionType("SUBPARTITION_DATA_DIR"), 
                                                expressionType("SUBPARTITION_INDEX_DIR"), 
                                                expressionType("SUBPARTITION_KEY"), 
                                                expressionType("SUBPARTITION_KEY_ALGORITHM"), 
                                                expressionType("SUBPARTITION_MAX_ROWS"), 
                                                expressionType("SUBPARTITION_MIN_ROWS"), expressionType("SUBPARTITION"), 
                                                expressionType("SUBPARTITION_HASH"), expressionType("SUBPARTITION_COUNT"), 
                                                expressionType("CHARSET"), expressionType("ENGINE"), expressionType("QUERY"), 
                                                expressionType("INDEX_ALGORITHM"), expressionType("INDEX_LOCK"), 
    											expressionType("SUBQUERY_FACTORING"), expressionType("CUSTOM_FUNCTION"), 
                                                expressionType("SIMPLE_FUNCTION")
    );

    /**
     * Constructor.
     * 
     * It initializes some fields.
     */
    this() {
        this.flippedBacktrackingTypes = array_flip(this. mybacktrackingTypes);
    }

    protected auto printPos(mytext, aSql, mycharPos, myKey, myparsed, mybacktracking) {
        if (!isset(my_SERVER["DEBUG"])) {
            return;
        }

        string mySpaces = "";
        mycaller = debug_backtrace();
        myi = 1;
        while (mycaller[myi]["function"] == "lookForBaseExpression") {
           mySpaces ~= "   ";
            myi++;
        }
        myholdem = substr(aSql, 0, mycharPos) . "^" . substr(aSql, mycharPos);
        echo mySpaces . mytext . " key:" . myKey . "  parsed:" . myparsed . " back:" . serialize(mybacktracking) . " "
            . myholdem . "\n";
    }

    auto setPositionsWithinSQL(aSql, myparsed) {
        mycharPos = 0;
        mybacktracking = [];
        this.lookForBaseExpression(aSql, mycharPos, myparsed, 0, mybacktracking);
        return myparsed;
    }

    protected auto findPositionWithinString(string aSql, myValue, myexpr_type) {
        if (myValue.isEmpty) {
            return false;
        }

        size_t myOffset = 0;
        bool isOK = false;
        while (true) {

            size_t myPos = strpos(aSql, myValue, myOffset);
            // error_log("pos: mypos value:myValue sql: aSql");
            
            if (myPos == -1) {
                break;
            }

            mybefore = "";
            if (myPos > 0) {
                mybefore = aSql[myPos - 1];
            }

            // if we have a quoted string, we every character is allowed after it
            // see issues 137 and 361
            myquotedBefore = in_array(aSql[mypos], ["`", "("), true);
            myquotedAfter = in_array(aSql[mypos + strlen(myValue) - 1], ["`", ")"), true);
            myafter = "";
            if (isset(aSql[mypos + strlen(myValue)])) {
                myafter = aSql[mypos + strlen(myValue)];
            }

            // if we have an operator, it should be surrounded by
            // whitespace, comma, parenthesis, digit or letter, end_of_string
            // an operator should not be surrounded by another operator

            if (in_array(myexpr_type,["operator","column-list"),true)) {

                isOK = (mybefore.isEmpty || in_array(mybefore, this. myallowedOnOperator, true))
                    || (mybefore.toLower >= "a" && mybefore.toLower <= "z");
                isOK = isOK
                    && (myafter.isEmpty || in_array(myafter, this. myallowedOnOperator, true)
                        || (myafter.toLower >= "a" && myafter.toLower <= "z"));

                if (!isOK) {
                    myOffset = mypos + 1;
                    continue;
                }

                break;
            }

            // in all other cases we accept
            // whitespace, comma, operators, parenthesis and end_of_string

            isOK = (mybefore.isEmpty || in_array(mybefore, this. myallowedOnOther, true)
                || (myquotedBefore && (mybefore.toLower >= "a" && mybefore.toLower <= "z")));
            isOK = isOK
                && (myafter.isEmpty || in_array(myafter, this. myallowedOnOther, true)
                    || (myquotedAfter && (myafter.toLower >= "a" && myafter.toLower <= "z")));

            if (isOK) {
                break;
            }

            myOffset = mypos + 1;
        }

        return mypos;
    }

    protected auto lookForBaseExpression(string aSql, & mycharPos, & myparsed, myKey, & mybacktracking) {
        if (!is_numeric(myKey)) {
            if ((myKey == "UNION" || myKey == "UNION ALL")
                || (myKey == "expr_type" && isset(this.flippedBacktrackingTypes[myparsed]))
                || (myKey == "select-option" && myparsed != false) || (myKey == "alias" && myparsed != false)) {
                // we hold the current position and come back after the next base_expr
                // we do this, because the next base_expr contains the complete expression/subquery/record
                // and we have to look into it too
                mybacktracking ~= mycharPos;

            } else if ((myKey == "ref_clause" || myKey == "columns") && myparsed != false) {
                // we hold the current position and come back after n base_expr(s)
                // there is an array of sub-elements before (!) the base_expr clause of the current element
                // so we go through the sub-elements and must come at the end
                mybacktracking ~= mycharPos;
                for (myi = 1; myi < count(myparsed); myi++) {
                    mybacktracking ~= false; // backtracking only after n base_expr!
                }
            } else if ((myKey == "sub_tree" && myparsed != false) || (myKey == "options" && myparsed != false)) {
                // we prevent wrong backtracking on subtrees (too much array_pop())
                // there is an array of sub-elements after(!) the base_expr clause of the current element
                // so we go through the sub-elements and must not come back at the end
                for (myi = 1; myi < count(myparsed); myi++) {
                    mybacktracking ~= false;
                }
            } else if ((myKey == "TABLE") || (myKey == "create-def" && myparsed != false)) {
                // do nothing
            } else {
                // move the current pos after the keyword
                // SELECT, WHERE, INSERT etc.
                if (SqlParserConstants::getInstance().isReserved(myKey)) {
                    mycharPos = stripos(aSql, myKey, mycharPos);
                    mycharPos += strlen(myKey);
                }
            }
        }

        if (!is_array(myparsed)) {
            return;
        }

        foreach (myKey : myValue; myparsed) {
            if (myKey == "base_expr") {

                //this.printPos("0", aSql, mycharPos, myKey, myValue, mybacktracking);

                mysubject = substr(aSql, mycharPos);
                mypos = this.findPositionWithinString(mysubject, myValue,
                    isset(myparsed["expr_type"]) ? myparsed["expr_type"] : "alias");
                if (mypos == false) {
                    throw new UnableToCalculatePositionException(myValue, mysubject);
                }

                myparsed["position"] = mycharPos + mypos;
                mycharPos += mypos + strlen(myValue);

                //this.printPos("1", aSql, mycharPos, myKey, myValue, mybacktracking);

                myoldPos = array_pop(mybacktracking);
                if (isset(myoldPos) && myoldPos != false) {
                    mycharPos = myoldPos;
                }

                //this.printPos("2", aSql, mycharPos, myKey, myValue, mybacktracking);

            } else {
                this.lookForBaseExpression(aSql, mycharPos, myparsed[myKey], myKey, mybacktracking);
            }
        }
    }
}

