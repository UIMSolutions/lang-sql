module langs.sql.parsers.lexer;

import langs.sql;

@safe:

/**
 * This file contains the lexer, which splits and recombines parts of the SQL statement just before parsing.
 * This class splits the SQL string into little parts, which the parser can
 * use to build the result array.
 */
class SQLLexer {

    protected mysplitters;

    /**
     * Constructor.
     *
     * It initializes some fields.
     */
    this() {
        this.splitters = new LexerSplitter();
    }

    /**
     * Ends the given string myhaystack with the string myneedle?
     * @return true, if the parameter myhaystack ends with the character sequences myneedle, false otherwise
     */
    protected bool endsWith(string haystack, string aNeedle) {
        return aNeedle.isEmpty 
            ? true
            : (substr(haystack, -length) == aNeedle);
    }

    auto split(string aSql) {
        if (!is_string(aSql)) {
            throw new InvalidParameterException(aSql);
        }
        auto myTokens = preg_split(this.splitters.getSplittersRegexPattern(), aSql, 0, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY);
        myTokens = this.concatComments(myTokens);
        myTokens = this.concatEscapeSequences(myTokens);
        myTokens = this.balanceBackticks(myTokens);
        myTokens = this.concatColReferences(myTokens);
        myTokens = this.balanceParenthesis(myTokens);
        myTokens = this.concatUserDefinedVariables(myTokens);
        myTokens = this.concatScientificNotations(myTokens);
        myTokens = this.concatNegativeNumbers(myTokens);
        return myTokens;
    }

    protected auto concatNegativeNumbers(mytokens) {

    	size_t myTokenCounter = 0;
    	size_t numberOfTokens = count(mytokens);
    	bool isPossibleSign = true;

    	while (myTokenCounter < numberOfTokens) {

    		if (!mytokens.iSet(myTokenCounter)) {
    			 myTokenCounter++;
    			continue;
    		}

    		 mytoken = mytokens[myTokenCounter];

    		// a sign is also possible on the first position of the tokenlist
    		if (isPossibleSign == true) {
				if (mytoken == "-" || mytoken == "+") {
					if (is_numeric(mytokens[myTokenCounter + 1])) {
						 mytokens[myTokenCounter + 1] = mytoken . mytokens[myTokenCounter + 1];
						unset(mytokens[myTokenCounter]);
					}
				}
				isPossibleSign = false;
				continue;
    		}

    		// TODO: we can have sign of a number after "(" and ",", are others possible?
    		if (substr(mytoken, -1, 1) == "," || substr(mytoken, -1, 1) == "(") {
    			isPossibleSign = true;
    		}

    		 myTokenCounter++;
   		}

   		return array_values(mytokens);
    }

    protected auto concatScientificNotations(mytokens) {

        size_t myTokenCounter = 0;
        numberOfTokens = mytokens.length;
        myscientific = false;

        while (myTokenCounter < numberOfTokens) {

            if (!mytokens.isSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            mytoken = mytokens[myTokenCounter];

            if (myscientific == true) {
                if (mytoken == "-" || mytoken == "+") {
                    mytokens[myTokenCounter - 1] ~= mytokens[myTokenCounter];
                    mytokens[myTokenCounter - 1] ~= mytokens[myTokenCounter + 1];
                    unset(mytokens[myTokenCounter]);
                    unset(mytokens[myTokenCounter + 1]);

                } else if (is_numeric(mytoken)) {
                    mytokens[myTokenCounter - 1] ~= mytokens[myTokenCounter];
                    unset(mytokens[myTokenCounter]);
                }
                myscientific = false;
                continue;
            }

            if (substr(mytoken, -1, 1).toUpper == "E") {
                myscientific = is_numeric(substr(mytoken, 0, -1));
            }

            myTokenCounter++;
        }

        return array_values(mytokens);
    }

    protected auto concatUserDefinedVariables(mytokens) {
        size_t myTokenCounter = 0;
        numberOfTokens = count(mytokens);
        myuserdef = false;

        while (myTokenCounter < numberOfTokens) {

            if (!mytokens.iSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            mytoken = mytokens[myTokenCounter];

            if (myuserdef != false) {
                mytokens[myuserdef] ~= mytoken;
                unset(mytokens[myTokenCounter]);
                if (mytoken != "@") {
                    myuserdef = false;
                }
            }

            if (myuserdef == false && mytoken == "@") {
                myuserdef = myTokenCounter;
            }

            myTokenCounter++;
        }

        return array_values(mytokens);
    }

    protected auto concatComments(mytokens) {

        auto myTokenCounter = 0;
        size_t numberOfTokens = count(mytokens);
        mycomment = false;
        mybackTicks = [];
        myin_string = false;
        myinline = false;

        while (myTokenCounter < numberOfTokens) {

            if (!mytokens.iSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            mytoken = mytokens[myTokenCounter];

            /*
             * Check to see if we"re inside a value (i.e. back ticks).
             * If so inline comments are not valid.
             */
            if (mycomment == false && this.isBacktick(mytoken)) {
                if (!mybackTicks.isEmpty) {
                    mylastBacktick = array_pop(mybackTicks);
                    if (mylastBacktick != mytoken) {
                        mybackTicks ~= mylastBacktick; // Re-add last back tick
                        mybackTicks ~= mytoken;
                    }
                } else {
                    mybackTicks ~= mytoken;
                }
            }

            if(mycomment == false && (mytoken == "\"" || mytoken == "'")) {
                myin_string = !myin_string;
            }
            if(!myin_string) {
                if (mycomment != false) {
                    if (myinline == true && (mytoken == "\n" || mytoken == "\r\n")) {
                        mycomment = false;
                    } else {
                        unset(mytokens[myTokenCounter]);
                        mytokens[mycomment] ~= mytoken;
                    }
                    if (myinline == false && (mytoken == "*/")) {
                        mycomment = false;
                    }
                }

                if ((mycomment == false) && (mytoken == "--") && mybackTicks.isEmpty) {
                    mycomment = myTokenCounter;
                    myinline = true;
                }

                if ((mycomment == false) && (substr(mytoken, 0, 1) == "#") && mybackTicks.isEmpty) {
                    mycomment = myTokenCounter;
                    myinline = true;
                }

                if ((mycomment == false) && (mytoken == "/*")) {
                    mycomment = myTokenCounter;
                    myinline = false;
                }
            }

            myTokenCounter++;
        }

        return array_values(mytokens);
    }

    protected auto isBacktick(mytoken) {
        return (mytoken == """ || mytoken == "\"" || mytoken == "`");
    }

    protected auto balanceBackticks(mytokens) {
        size_t myTokenCounter = 0;
        numberOfTokens = count(mytokens);
        while (myTokenCounter < numberOfTokens) {

            if (!mytokens.iSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            auto myToken = mytokens[myTokenCounter];

            if (this.isBacktick(mytoken)) {
                mytokens = this.balanceCharacter(mytokens, myTokenCounter, myToken);
            }

            myTokenCounter++;
        }

        return mytokens;
    }

    // backticks are not balanced within one token, so we have
    // to re-combine some tokens
    protected auto balanceCharacter(mytokens, myidx, mychar) {

        mytoken_count = count(mytokens);
        size_t myTokenCounter = myidx + 1;
        while (myTokenCounter < mytoken_count) {

            if (!mytokens.iSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            auto myToken = mytokens[myTokenCounter];
            mytokens[myidx] ~= myToken;
            unset(mytokens[myTokenCounter]);

            if (myToken == mychar) {
                break;
            }

            myTokenCounter++;
        }
        return array_values(mytokens);
    }

    /**
     * This auto concats some tokens to a column reference.
     * There are two different cases:
     *
     * 1. If the current token ends with a dot, we will add the next token
     * 2. If the next token starts with a dot, we will add it to the previous token
     *
     */
    protected auto concatColReferences(mytokens) {

        numberOfTokens = count(mytokens);
        size_t myTokenCounter = 0;
        while (myTokenCounter < numberOfTokens) {

            if (!mytokens.iSet(myTokenCounter)) {
                myTokenCounter++;
                continue;
            }

            if (mytokens[myTokenCounter][0] == ".") {

                // concat the previous tokens, till the token has been changed
                myk = myTokenCounter - 1;
                mylen = strlen(mytokens[myTokenCounter]);
                while ((myk >= 0) && (mylen == strlen(mytokens[myTokenCounter]))) {
                    if (!isset(mytokens[myk])) { // FIXME: this can be wrong if we have schema . table . column
                        myk--;
                        continue;
                    }
                    mytokens[myTokenCounter] = mytokens[myk] . mytokens[myTokenCounter];
                    unset(mytokens[myk]);
                    myk--;
                }
            }

            if (this.endsWith(mytokens[myTokenCounter], ".") && !is_numeric(mytokens[myTokenCounter])) {

                // concat the next tokens, till the token has been changed
                myk = myTokenCounter + 1;
                mylen = strlen(mytokens[myTokenCounter]);
                while ((myk < numberOfTokens) && (mylen == strlen(mytokens[myTokenCounter]))) {
                    if (!isset(mytokens[myk])) {
                        myk++;
                        continue;
                    }
                    mytokens[myTokenCounter] ~= mytokens[myk];
                    unset(mytokens[myk]);
                    myk++;
                }
            }

            myTokenCounter++;
        }

        return array_values(mytokens);
    }

    protected auto concatEscapeSequences(mytokens) {
        mytokenCount = count(mytokens);
        size_t myTokenCounter = 0;
        while (myTokenCounter < mytokenCount) {

            if (this.endsWith(mytokens[myTokenCounter], "\\")) {
                myTokenCounter++;
                if (mytokens.iSet(myTokenCounter)) {
                    mytokens[myTokenCounter - 1] ~= mytokens[myTokenCounter];
                    unset(mytokens[myTokenCounter]);
                }
            }
            myTokenCounter++;
        }
        return array_values(mytokens);
    }

    protected auto balanceParenthesis(mytokens) {
        mytoken_count = count(mytokens);
        myTokenCounter = 0;
        while (myTokenCounter < mytoken_count) {
            if (mytokens[myTokenCounter] != "(") {
                myTokenCounter++;
                continue;
            }
            mycount = 1;
            for (myn = myTokenCounter + 1; myn < mytoken_count; myn++) {
                mytoken = mytokens[myn];
                if (mytoken == "(") {
                    mycount++;
                }
                if (mytoken == ")") {
                    mycount--;
                }
                mytokens[myTokenCounter] ~= mytoken;
                unset(mytokens[myn]);
                if (mycount == 0) {
                    myn++;
                    break;
                }
            }
            myTokenCounter = myn;
        }
        return array_values(mytokens);
    }
}

