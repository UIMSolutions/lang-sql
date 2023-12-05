module lang.sql.parsers.lexer;

import lang.sql;

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

    protected auto concatNegativeNumbers( mytokens) {

    	size_t myi = 0;
    	numberOfTokens = count( mytokens);
    	bool isPossibleSign = true;

    	while ( myi < numberOfTokens) {

    		if (! mytokens.iSet( myi)) {
    			 myi++;
    			continue;
    		}

    		 mytoken = mytokens[ myi];

    		// a sign is also possible on the first position of the tokenlist
    		if (isPossibleSign == true) {
				if ( mytoken == "-" || mytoken == "+") {
					if (is_numeric( mytokens[ myi + 1])) {
						 mytokens[ myi + 1] = mytoken . mytokens[ myi + 1];
						unset( mytokens[ myi]);
					}
				}
				isPossibleSign = false;
				continue;
    		}

    		// TODO: we can have sign of a number after "(" and ",", are others possible?
    		if (substr( mytoken, -1, 1) == "," || substr( mytoken, -1, 1) == "(") {
    			isPossibleSign = true;
    		}

    		 myi++;
   		}

   		return array_values( mytokens);
    }

    protected auto concatScientificNotations( mytokens) {

        myi = 0;
        numberOfTokens = mytokens.length;
        myscientific = false;

        while ( myi < numberOfTokens) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            mytoken = mytokens[ myi];

            if ( myscientific == true) {
                if ( mytoken == "-" || mytoken == "+") {
                    mytokens[ myi - 1] ~= mytokens[ myi];
                    mytokens[ myi - 1] ~= mytokens[ myi + 1];
                    unset( mytokens[ myi]);
                    unset( mytokens[ myi + 1]);

                } else if (is_numeric( mytoken)) {
                    mytokens[ myi - 1] ~= mytokens[ myi];
                    unset( mytokens[ myi]);
                }
                myscientific = false;
                continue;
            }

            if (substr( mytoken, -1, 1).toUpper == "E") {
                myscientific = is_numeric(substr( mytoken, 0, -1));
            }

            myi++;
        }

        return array_values( mytokens);
    }

    protected auto concatUserDefinedVariables( mytokens) {
        myi = 0;
        numberOfTokens = count( mytokens);
        myuserdef = false;

        while ( myi < numberOfTokens) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            mytoken = mytokens[ myi];

            if ( myuserdef != false) {
                mytokens[ myuserdef] ~= mytoken;
                unset( mytokens[ myi]);
                if ( mytoken != "@") {
                    myuserdef = false;
                }
            }

            if ( myuserdef == false && mytoken == "@") {
                myuserdef = myi;
            }

            myi++;
        }

        return array_values( mytokens);
    }

    protected auto concatComments( mytokens) {

        myi = 0;
        numberOfTokens = count( mytokens);
        mycomment = false;
        mybackTicks = [];
        myin_string = false;
        myinline = false;

        while ( myi < numberOfTokens) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            mytoken = mytokens[ myi];

            /*
             * Check to see if we"re inside a value (i.e. back ticks).
             * If so inline comments are not valid.
             */
            if ( mycomment == false && this.isBacktick( mytoken)) {
                if (!empty( mybackTicks)) {
                    mylastBacktick = array_pop( mybackTicks);
                    if ( mylastBacktick != mytoken) {
                        mybackTicks ~= mylastBacktick; // Re-add last back tick
                        mybackTicks ~= mytoken;
                    }
                } else {
                    mybackTicks ~= mytoken;
                }
            }

            if( mycomment == false && ( mytoken == "\"" || mytoken == """)) {
                myin_string = ! myin_string;
            }
            if(! myin_string) {
                if ( mycomment != false) {
                    if ( myinline == true && ( mytoken == "\n" || mytoken == "\r\n")) {
                        mycomment = false;
                    } else {
                        unset( mytokens[ myi]);
                        mytokens[ mycomment] ~= mytoken;
                    }
                    if ( myinline == false && ( mytoken == "*/")) {
                        mycomment = false;
                    }
                }

                if (( mycomment == false) && ( mytoken == "--") && empty( mybackTicks)) {
                    mycomment = myi;
                    myinline = true;
                }

                if (( mycomment == false) && (substr( mytoken, 0, 1) == "#") && empty( mybackTicks)) {
                    mycomment = myi;
                    myinline = true;
                }

                if (( mycomment == false) && ( mytoken == "/*")) {
                    mycomment = myi;
                    myinline = false;
                }
            }

            myi++;
        }

        return array_values( mytokens);
    }

    protected auto isBacktick( mytoken) {
        return ( mytoken == """ || mytoken == "\"" || mytoken == "`");
    }

    protected auto balanceBackticks( mytokens) {
        myi = 0;
        numberOfTokens = count( mytokens);
        while ( myi < numberOfTokens) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            auto myToken = mytokens[ myi];

            if (this.isBacktick( mytoken)) {
                mytokens = this.balanceCharacter( mytokens, myi, myToken);
            }

            myi++;
        }

        return mytokens;
    }

    // backticks are not balanced within one token, so we have
    // to re-combine some tokens
    protected auto balanceCharacter( mytokens, myidx, mychar) {

        mytoken_count = count( mytokens);
        myi = myidx + 1;
        while ( myi < mytoken_count) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            auto myToken = mytokens[ myi];
            mytokens[ myidx] ~= myToken;
            unset( mytokens[ myi]);

            if (myToken == mychar) {
                break;
            }

            myi++;
        }
        return array_values( mytokens);
    }

    /**
     * This auto concats some tokens to a column reference.
     * There are two different cases:
     *
     * 1. If the current token ends with a dot, we will add the next token
     * 2. If the next token starts with a dot, we will add it to the previous token
     *
     */
    protected auto concatColReferences( mytokens) {

        numberOfTokens = count( mytokens);
        myi = 0;
        while ( myi < numberOfTokens) {

            if (! mytokens.iSet( myi)) {
                myi++;
                continue;
            }

            if ( mytokens[ myi][0] == ".") {

                // concat the previous tokens, till the token has been changed
                myk = myi - 1;
                mylen = strlen( mytokens[ myi]);
                while (( myk >= 0) && ( mylen == strlen( mytokens[ myi]))) {
                    if (!isset( mytokens[ myk])) { // FIXME: this can be wrong if we have schema . table . column
                        myk--;
                        continue;
                    }
                    mytokens[ myi] = mytokens[ myk] . mytokens[ myi];
                    unset( mytokens[ myk]);
                    myk--;
                }
            }

            if (this.endsWith( mytokens[ myi], ".") && !is_numeric( mytokens[ myi])) {

                // concat the next tokens, till the token has been changed
                myk = myi + 1;
                mylen = strlen( mytokens[ myi]);
                while (( myk < numberOfTokens) && ( mylen == strlen( mytokens[ myi]))) {
                    if (!isset( mytokens[ myk])) {
                        myk++;
                        continue;
                    }
                    mytokens[ myi] ~= mytokens[ myk];
                    unset( mytokens[ myk]);
                    myk++;
                }
            }

            myi++;
        }

        return array_values( mytokens);
    }

    protected auto concatEscapeSequences( mytokens) {
        mytokenCount = count( mytokens);
        myi = 0;
        while ( myi < mytokenCount) {

            if (this.endsWith( mytokens[ myi], "\\")) {
                myi++;
                if ( mytokens.iSet( myi)) {
                    mytokens[ myi - 1] ~= mytokens[ myi];
                    unset( mytokens[ myi]);
                }
            }
            myi++;
        }
        return array_values( mytokens);
    }

    protected auto balanceParenthesis( mytokens) {
        mytoken_count = count( mytokens);
        myi = 0;
        while ( myi < mytoken_count) {
            if ( mytokens[ myi] != "(") {
                myi++;
                continue;
            }
            mycount = 1;
            for ( myn = myi + 1; myn < mytoken_count; myn++) {
                mytoken = mytokens[ myn];
                if ( mytoken == "(") {
                    mycount++;
                }
                if ( mytoken == ")") {
                    mycount--;
                }
                mytokens[ myi] ~= mytoken;
                unset( mytokens[ myn]);
                if ( mycount == 0) {
                    myn++;
                    break;
                }
            }
            myi = myn;
        }
        return array_values( mytokens);
    }
}

