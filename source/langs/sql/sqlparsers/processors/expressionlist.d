module langs.sql.sqlparsers.processors.expressionlist;

import lang.sql;

@safe:

// This class processes expression lists.
class ExpressionListProcessor : AbstractProcessor {

    auto process(tokens) {
         myresultList = [];
        bool isSkipNext = false;
         myprev = new ExpressionToken();

        foreach (myKey, myValue; tokens) {


            if (this.isCommentToken(myValue)) {
                 myresultList ~= super.processComment(myValue);
                continue;
            }

             mycurr = new ExpressionToken(myKey, myValue);

            if ( mycurr.isWhitespaceToken()) {
                continue;
            }

            if (isSkipNext) {
                // skip the next non-whitespace token
                isSkipNext = false;
                continue;
            }

            /* is it a subquery? */
            if ( mycurr.isSubQueryToken()) {

                auto myProcessor = new DefaultProcessor(this.options);
                 mycurr.setSubTree( myprocessor.process(this.removeParenthesisFromStart( mycurr.getTrim())));
                 mycurr.setTokenType(expressionType("SUBQUERY"));

            } else if ( mycurr.isEnclosedWithinParenthesis()) {
                /* is it an in-list? */

                 mylocalTokenList = this.splitSQLIntoTokens(this.removeParenthesisFromStart( mycurr.getTrim()));

                if ( myprev.getUpper() == "IN") {

                    foreach (myKey, myValue;  mylocalTokenList) {
                        tempToken = new ExpressionToken(myKey, myValue);
                        if (tempToken.isCommaToken()) {
                            unset( mylocalTokenList[ myk]);
                        }
                    }

                     mylocalTokenList = array_values( mylocalTokenList);
                     mycurr.setSubTree(this.process( mylocalTokenList));
                     mycurr.setTokenType(expressionType("IN_LIST"));
                } else if ( myprev.getUpper() == "AGAINST") {

                    matchModeToken = false;
                    foreach ( mylocalTokenList as myKey, myValue) {

                        ExpressionToken tempToken = new ExpressionToken(myKey, myValue);
                        switch (tempToken.getUpper()) {
                        case "WITH":
                            matchModeToken = "WITH QUERY EXPANSION";
                            break;
                        case "IN":
                            matchModeToken = "IN BOOLEAN MODE";
                            break;

                        default:
                        }

                        if (matchModeToken != false) {
                            unset( mylocalTokenList[ myk]);
                        }
                    }

                    tempToken = this.process( mylocalTokenList);

                    if (matchModeToken != false) {
                        ExpressionToken matchModeToken = new ExpressionToken(0, matchModeToken);
                        matchModeToken.setTokenType(expressionType("MATCH_MODE"));
                        tempToken ~= matchModeToken.toArray();
                    }

                     mycurr.setSubTree(tempToken);
                     mycurr.setTokenType(expressionType("MATCH_ARGUMENTS"));
                     myprev.setTokenType(expressionType("SIMPLE_FUNCTION"));

                } else if ( myprev.isColumnReference() ||  myprev.isFunction() ||  myprev.isAggregateFunction()
                    ||  myprev.isCustomFunction()) {

                    // if we have a colref followed by a parenthesis pair,
                    // it isn"t a colref, it is a user-function

                    // TODO: this should be a method, because we need the same code
                    // below for unspecified tokens (expressions).

                    localExpressionToken = new ExpressionToken();
                     mytmpExprList = [];

                    foreach (myKey, myValue;  mylocalTokenList) {
                        ExpressionToken tempToken = new ExpressionToken(myKey, myValue);
                        if (!tempToken.isCommaToken()) {
                            localExpressionToken.addToken(myValue);
                             mytmpExprList ~= myValue;
                        } else {
                            // an expression could have multiple parts split by operands
                            // if we have a comma, it is a split-point for expressions
                             mytmpExprList = array_values( mytmpExprList);
                             mylocalExprList = this.process( mytmpExprList);

                            if ( mylocalExprList.length > 1) {
                                localExpressionToken.setSubTree( mylocalExprList);
                                localExpressionToken.setTokenType(expressionType("EXPRESSION"));
                                 mylocalExprList = localExpressionToken.toArray();
                                 mylocalExprList["alias"] = false;
                                 mylocalExprList = [ mylocalExprList);
                            }

                            if (! mycurr.getSubTree()) {
                                if (! mylocalExprList.isEmpty) {
                                     mycurr.setSubTree( mylocalExprList);
                                }
                            } else {
                                 mytmpExprList =  mycurr.getSubTree();
                                 mycurr.setSubTree(array_merge( mytmpExprList,  mylocalExprList));
                            }

                             mytmpExprList = [];
                            ExpressionToken localExpressionToken = new ExpressionToken();
                        }
                    }

                     mytmpExprList = array_values( mytmpExprList);
                     mylocalExprList = this.process( mytmpExprList);

                    if ( mylocalExprList.length > 1) {
                        localExpressionToken.setSubTree( mylocalExprList);
                        localExpressionToken.setTokenType(expressionType("EXPRESSION"));
                         mylocalExprList = localExpressionToken.toArray();
                         mylocalExprList["alias"] = false;
                         mylocalExprList = [ mylocalExprList];
                    }

                    if (! mycurr.getSubTree()) {
                        if (!empty( mylocalExprList)) {
                             mycurr.setSubTree( mylocalExprList);
                        }
                    } else {
                         mytmpExprList =  mycurr.getSubTree();
                         mycurr.setSubTree(array_merge( mytmpExprList,  mylocalExprList));
                    }

                     myprev.setSubTree( mycurr.getSubTree());
                    if ( myprev.isColumnReference()) {
                        if (SqlParserConstants::getInstance().isCustomFunction( myprev.getUpper())) {
                             myprev.setTokenType(expressionType("CUSTOM_FUNCTION"));
                        } else {
                             myprev.setTokenType(expressionType("SIMPLE_FUNCTION"));
                        }
                         myprev.setNoQuotes(null, null, this.options);
                    }

                    array_pop( myresultList);
                     mycurr =  myprev;
                }

                // we have parenthesis, but it seems to be an expression
                if ( mycurr.isUnspecified()) {
                     mytmpExprList = array_values( mylocalTokenList);
                     mylocalExprList = this.process( mytmpExprList);

                     mycurr.setTokenType(expressionType("BRACKET_EXPRESSION"));
                    if (! mycurr.getSubTree()) {
                        if (!empty( mylocalExprList)) {
                             mycurr.setSubTree( mylocalExprList);
                        }
                    } else {
                         mytmpExprList =  mycurr.getSubTree();
                         mycurr.setSubTree(array_merge( mytmpExprList,  mylocalExprList));
                    }
                }

            } else if ( mycurr.isVariableToken()) {

                // a variable
                 it can be quoted

                 mycurr.setTokenType(this.getVariableType( mycurr.getUpper()));
                 mycurr.setSubTree(false);
                 mycurr.setNoQuotes(( mycurr.getToken().strip, "@").strip, "`"\"", this.options);

            } else {
                /* it is either an operator, a colref or a constant */
                switch ( mycurr.getUpper()) {

                case "*":
                     mycurr.setSubTree(false); // o subtree

                    // single or first element of expression list . all-column-alias
                    if (empty( myresultList)) {
                         mycurr.setTokenType(expressionType("COLREF"));
                        break;
                    }

                    // if the last token is colref, const or expression
                    // then * is an operator
                    // but if the previous colref ends with a dot, the * is the all-columns-alias
                    if (
                        ! myprev.isColumnReference()
                        && ! myprev.isConstant()
                        && ! myprev.isExpression()
                        && ! myprev.isBracketExpression()
                        && ! myprev.isAggregateFunction()
                        && ! myprev.isVariable()
                        && ! myprev.isFunction()
                    ) {
                         mycurr.setTokenType(expressionType("COLREF"));
                        break;
                    }

                    if ( myprev.isColumnReference() &&  myprev.endsWith(".")) {
                         myprev.addToken("*"); // tablealias dot *
                        continue 2; // skip the current token
                    }

                     mycurr.setTokenType(expressionType("OPERATOR"));
                    break;

                case ":=":
                case "AND":
                case "&&":
                case "BETWEEN":
                case "BINARY":
                case "&":
                case "~":
                case "|":
                case "^":
                case "DIV":
                case "/":
                case "<: ":
                case "=":
                case ">=":
                case ">":
                case "IS":
                case "NOT":
                case "<<":
                case "<=":
                case "<":
                case "LIKE":
                case "%":
                case "!=":
                case "!=":
                case "REGEXP":
                case "!":
                case "||":
                case "OR":
                case ">>":
                case "RLIKE":
                case "SOUNDS":
                case "XOR":
                case "IN":
                     mycurr.setSubTree(false);
                     mycurr.setTokenType(expressionType("OPERATOR"));
                    break;

                case "NULL":
                     mycurr.setSubTree(false);
                     mycurr.setTokenType(expressionType("CONSTANT"));
                    break;

                case "-":
                case "+":
                // differ between preceding sign and operator
                     mycurr.setSubTree(false);

                    if ( myprev.isColumnReference() ||  myprev.isFunction() ||  myprev.isAggregateFunction()
                        ||  myprev.isConstant() ||  myprev.isSubQuery() ||  myprev.isExpression()
                        ||  myprev.isBracketExpression() ||  myprev.isVariable() ||  myprev.isCustomFunction()) {
                         mycurr.setTokenType(expressionType("OPERATOR"));
                    } else {
                         mycurr.setTokenType(expressionType("SIGN"));
                    }
                    break;

                default:
                     mycurr.setSubTree(false);

                    switch ( mycurr.getToken(0)) {
                    case "\"":
                    // it is a string literal
                         mycurr.setTokenType(expressionType("CONSTANT"));
                        break;
                    case "\"":
                        if (!this.options.getANSIQuotes()) {
                        // If we"re not using ANSI quotes, this is a string literal.
                             mycurr.setTokenType(expressionType("CONSTANT"));
                            break;
                        }
                        // Otherwise continue to the next case
                    case "`":
                    // it is an escaped colum name
                         mycurr.setTokenType(expressionType("COLREF"));
                         mycurr.setNoQuotes( mycurr.getToken(), null, this.options);
                        break;

                    default:
                        if ( mycurr.getToken().isNumeric) {

                            if ( myprev.isSign()) {
                                 myprev.addToken( mycurr.getToken()); // it is a negative numeric constant
                                 myprev.setTokenType(expressionType("CONSTANT"));
                                continue 3;
                                // skip current token
                            } else {
                                 mycurr.setTokenType(expressionType("CONSTANT"));
                            }
                        } else {
                             mycurr.setTokenType(expressionType("COLREF"));
                             mycurr.setNoQuotes( mycurr.getToken(), null, this.options);
                        }
                        break;
                    }
                }
            }

            /* is a reserved word? */
            if (! mycurr.isOperator() && ! mycurr.isInList() && ! mycurr.isFunction() && ! mycurr.isAggregateFunction()
                && ! mycurr.isCustomFunction() && SqlParserConstants::getInstance().isReserved( mycurr.getUpper())) {

	             mynext = tokens.isSet(  myk + 1 ) ? new ExpressionToken(  myk + 1, tokens[  myk + 1 ] ) : new ExpressionToken();
                 myisEnclosedWithinParenthesis =  mynext.isEnclosedWithinParenthesis();
	            if ( myisEnclosedWithinParenthesis && SqlParserConstants::getInstance().isCustomFunction( mycurr.getUpper())) {
                     mycurr.setTokenType(expressionType("CUSTOM_FUNCTION"));
                     mycurr.setNoQuotes(null, null, this.options);

                } else if ( myisEnclosedWithinParenthesis && SqlParserConstants::getInstance().isAggregateFunction( mycurr.getUpper())) {
                     mycurr.setTokenType(expressionType("AGGREGATE_FUNCTION"));
                     mycurr.setNoQuotes(null, null, this.options);

                } else if ( mycurr.getUpper() == "NULL") {
                    // it is a reserved word, but we would like to set it as constant
                     mycurr.setTokenType(expressionType("CONSTANT");

                } else {
                    if ( myisEnclosedWithinParenthesis && SqlParserConstants::getInstance().isParameterizedFunction( mycurr.getUpper())) {
                        // issue 60: check functions with parameters
                        // . colref (we check parameters later)
                        // . if there is no parameter, we leave the colref
                         mycurr.setTokenType(expressionType("COLREF"));

                    } else if ( myisEnclosedWithinParenthesis && SqlParserConstants::getInstance().isFunction( mycurr.getUpper())) {
                         mycurr.setTokenType(expressionType("SIMPLE_FUNCTION"));
                         mycurr.setNoQuotes(null, null, this.options);

                    }  else if (! myisEnclosedWithinParenthesis && SqlParserConstants::getInstance().isFunction( mycurr.getUpper())) {
	                    // Colname using auto name.
                    	 mycurr.setTokenType(expressionType("COLREF"));
                    } else {
                         mycurr.setTokenType(expressionType("RESERVED"));
                         mycurr.setNoQuotes(null, null, this.options);
                    }
                }
            }

            // issue 94, INTERVAL 1 MONTH
            if ( mycurr.isConstant() && SqlParserConstants::getInstance().isParameterizedFunction( myprev.getUpper())) {
                 myprev.setTokenType(expressionType("RESERVED"));
                 myprev.setNoQuotes(null, null, this.options);
            }

            if ( myprev.isConstant() && SqlParserConstants::getInstance().isParameterizedFunction( mycurr.getUpper())) {
                 mycurr.setTokenType(expressionType("RESERVED"));
                 mycurr.setNoQuotes(null, null, this.options);
            }

            if ( mycurr.isUnspecified()) {
                 mycurr.setTokenType(expressionType("EXPRESSION"));
                 mycurr.setNoQuotes(null, null, this.options);
                 mycurr.setSubTree(this.process(this.splitSQLIntoTokens( mycurr.getTrim())));
            }

             myresultList ~=  mycurr;
             myprev =  mycurr;
        } // end of for-loop

        return this.toArray( myresultList);
    }
}
