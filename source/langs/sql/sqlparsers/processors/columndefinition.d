
module langs.sql.sqlparsers.processors.columndefinition;

import lang.sql;

@safe:

/**
 * This file : the processor for column definition part of a CREATE TABLE statement.
 * This class processes the column definition part of a CREATE TABLE statement.
 * */
class ColumnDefinitionProcessor : Processor {

    protected Json processExpressionList(myparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
       myExpression = this.removeParenthesisFromStart(myparsed);
       myExpression = this.splitSQLIntoTokens(myExpression);
       myExpression = this.removeComma(myExpression);
        return myProcessor.process(myExpression);
    }

    protected Json processReferenceDefinition(myparsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessor.process(myparsed);
    }

    protected auto removeComma(mytokens) {
        auto result = [];
        foreach (myToken; mytokens) {
            if (myToken.strip != ",") {
                result ~= myToken;
            }
        }
        return result;
    }

    protected string buildColDef(myExpression, baseExpression, myoptions, myrefs, myKey) {
       myExpression = createExpression("COLUMN_TYPE"), "base_expr" : baseExpression, "sub_tree" : myExpression];

        // add options first
       myExpression["sub_tree"] = array_merge(myExpression["sub_tree"], myoptions["sub_tree"]);
        unset(myoptions["sub_tree"]);
       myExpression = array_merge(myExpression, myoptions);

        // followed by references
        if (sizeof(myrefs) != 0) {
           myExpression["sub_tree"] = array_merge(myExpression["sub_tree"], myrefs);
        }

       myExpression["till"] = myKey;
        return myExpression;
    }

    Json process(strig[] tokens) {
        string baseExpression = "";
        string currentCategory = "";
       myExpression = [];
        myrefs = [];
        myoptions = ["unique" : false, "nullable" : true, "auto_inc" : false, "primary" : false,
                         "sub_tree" : []];
        myskip = 0;

        foreach (myKey, myToken; mytokens) {

            string strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if (myskip > 0) {
                myskip--;
                continue;
            }

            if (myskip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case ",":
            // we stop on a single comma and return
            // the myExpression entry and the index myKey
               myExpression = this.buildColDef(myExpression, (substr(baseExpression, 0, -myToken.length)).strip, myoptions, myrefs,
                   myKey - 1);
                break 2;

            case "VARCHAR":
            case "VARCHARACTER": // Alias for VARCHAR
                Json newExpresion = createExpression("DATA_TYPE", strippedToken);
                newExpresion["length"] = false;
                myExpression ~= newExpression;

                myPrevousCategory = "TEXT";
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
                continue 2;

            case "VARBINARY":
                Json newExpresion = createExpression(
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "length" : false];
               myPrevousCategory = upperToken;
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
                continue 2;

            case "UNSIGNED":
                foreach (array_reverse(array_keys(myExpression)) as myi) {
                    if (myExpression[myi].isSet("expr_type") && (expressionType("DATA_TYPE") == myExpression[myi]["expr_type"])) {
                       myExpression[myi]["unsigned"] = true;
                        break;
                    }
                }
	            myoptions["sub_tree"] ~= createExpression("RESERVED", strippedToken];
                continue 2;

            case "ZEROFILL":
                mylast = array_pop(myExpression);
                mylast["zerofill"] = true;
               myExpression ~= mylast;
	            myoptions["sub_tree"] ~= createExpression("RESERVED", strippedToken);
                continue 2;

            case "BIT":
            case "TINYBIT":
            case "TINYINT":
            case "SMALLINT":
            case "INT2":       // Alias of SMALLINT
            case "MEDIUMINT":
            case "INT3":       // Alias of MEDIUMINT
            case "MIDDLEINT":  // Alias of MEDIUMINT
            case "INT":
            case "INTEGER":
            case "INT4":       // Alias of INT
            case "BIGINT":
            case "INT8":       // Alias of BIGINT
            case "BOOL":
            case "BOOLEAN":
                Json newExpresion = createExpression("DATA_TYPE", strippedToken);
                newExpression["unsigned"] = false;
                newExpression["zerofill"] = false;
                newExpression["length"]   = false;

                myExpression ~= newExpression 
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
                myPrevousCategory = upperToken;
                continue 2;

            case "BINARY":
                if (currentCategory == "TEXT") {
                    mylast = array_pop(myExpression);
                    mylast["binary"] = true;
                    mylast["sub_tree"] ~= createEXpression("RESERVED", strippedToken);
                   myExpression ~= mylast;
                    continue 2;
                }

                Json  newExpression = createExpression("DATA_TYPE", strippedToken);
                newExpression["length"] = false;
                myExpression ~= newExpression;
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
                myPrevousCategory = upperToken;
                continue 2;

            case "CHAR":
            case "CHARACTER":  // Alias for CHAR
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "length" : false];
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
               myPrevousCategory = "TEXT";
                continue 2;

            case "REAL":
            case "DOUBLE":
            case "FLOAT8":     // Alias for DOUBLE
            case "FLOAT":
            case "FLOAT4":     // Alias for FLOAT
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "unsigned" : false,
                                "zerofill" : false];
                currentCategory = "TWO_PARAM_PARENTHESIS";
               myPrevousCategory = upperToken;
                continue 2;

            case "DECIMAL":
            case "NUMERIC":
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "unsigned" : false,
                                "zerofill" : false];
                currentCategory = "TWO_PARAM_PARENTHESIS";
               myPrevousCategory = upperToken;
                continue 2;

            case "YEAR":
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "length" : false];
                currentCategory = "SINGLE_PARAM_PARENTHESIS";
               myPrevousCategory = upperToken;
                continue 2;

            case "DATE":
            case "TIME":
            case "TIMESTAMP":
            case "DATETIME":
            case "TINYBLOB":
            case "BLOB":
            case "MEDIUMBLOB":
            case "LONGBLOB":
               myExpression ~= createExpression("DATA_TYPE"), "base_expr": strippedToken];
               myPrevousCategory = currentCategory = upperToken;
                continue 2;

            // the next token can be BINARY
            case "TINYTEXT":
            case "TEXT":
            case "MEDIUMTEXT":
            case "LONGTEXT":
               myPrevousCategory = currentCategory = "TEXT";
               myExpression ~= createExpression("DATA_TYPE"), "base_expr" : strippedToken, "binary" : false];
                continue 2;

            case "ENUM":
                currentCategory = "MULTIPLE_PARAM_PARENTHESIS";
               myPrevousCategory = "TEXT";
               myExpression ~= createExpression("RESERVED"), "base_expr" : strippedToken, "sub_tree" : false];
                continue 2;

            case "GEOMETRY":
            case "POINT":
            case "LINESTRING":
            case "POLYGON":
            case "MULTIPOINT":
            case "MULTILINESTRING":
            case "MULTIPOLYGON":
            case "GEOMETRYCOLLECTION":
               myExpression ~= createExpression("DATA_TYPE"), "base_expr": strippedToken];
               myPrevousCategory = currentCategory = upperToken;
                // TODO: is it right?
                // spatial types
                continue 2;

            case "CHARACTER":
                currentCategory = "CHARSET";
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case "SET":
				if (currentCategory == "CHARSET") {
    	            myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
				} else {
	                currentCategory = "MULTIPLE_PARAM_PARENTHESIS";
    	           myPrevousCategory = "TEXT";
        	       myExpression ~= createExpression("RESERVED"), "base_expr" : strippedToken, "sub_tree" : false];
				}
                continue 2;

            case "COLLATE":
                currentCategory = upperToken;
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case "NOT":
            case "NULL":
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                if (myoptions["nullable"]) {
                    myoptions["nullable"] = (upperToken == "NOT" ? false : true);
                }
                continue 2;

            case "DEFAULT":
            case "COMMENT":
                currentCategory = upperToken;
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case "AUTO_INCREMENT":
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                myoptions["auto_inc"] = true;
                continue 2;

            case "COLUMN_FORMAT":
            case "STORAGE":
                currentCategory = upperToken;
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case "UNIQUE":
            // it can follow a KEY word
                currentCategory = upperToken;
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                myoptions["unique"] = true;
                continue 2;

            case "PRIMARY":
            // it must follow a KEY word
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case "KEY":
                myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                if (currentCategory != "UNIQUE") {
                    myoptions["primary"] = true;
                }
                continue 2;

            case "REFERENCES":
                myrefs = this.processReferenceDefinition(array_splice(mytokens, myKey - 1, null, true));
                myskip = myrefs["till"] - myKey;
                unset(myrefs["till"]);
                // TODO: check this, we need the last comma
                continue 2;

            default:
                switch (currentCategory) {

                case "STORAGE":
                    if (upperToken == "DISK" || upperToken == "MEMORY" || upperToken == "DEFAULT") {
                        myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                        myoptions["storage"] = strippedToken;
                        continue 3;
                    }
                    // else ?
                    break;

                case "COLUMN_FORMAT":
                    if (upperToken == "FIXED" || upperToken == "DYNAMIC" || upperToken == "DEFAULT") {
                        myoptions["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                        myoptions["col_format"] = strippedToken;
                        continue 3;
                    }
                    // else ?
                    break;

                case "COMMENT":
                // this is the comment string
                    myoptions["sub_tree"] ~= createExpression("COMMENT"), "base_expr": strippedToken];
                    myoptions["comment"] = strippedToken;
                    currentCategory = myPrevousCategory;
                    break;

                case "DEFAULT":
                // this is the default value
                    myoptions["sub_tree"] ~= createExpression("DEF_VALUE"), "base_expr": strippedToken];
                    myoptions["default"] = strippedToken;
                    currentCategory = myPrevousCategory;
                    break;

                case "COLLATE":
                // this is the collation name
                    myoptions["sub_tree"] ~= createExpression("COLLATE"), "base_expr": strippedToken];
                    myoptions["collate"] = strippedToken;
                    currentCategory = myPrevousCategory;
                    break;

                case "CHARSET":
                // this is the character set name
                    myoptions["sub_tree"] ~= createExpression("CHARSET"), "base_expr": strippedToken];
                    myoptions["charset"] = strippedToken;
                    currentCategory = myPrevousCategory;
                  break;

                case "SINGLE_PARAM_PARENTHESIS":
                    myparsed = this.removeParenthesisFromStart(strippedToken);
                    myparsed = createExpression("CONSTANT"), "base_expr" : myparsed.strip);
                    mylast = array_pop(myExpression);
                    mylast["length"] = myparsed.baseExpression;

                   myExpression ~= mylast;
                   myExpression ~= createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                    "sub_tree" : [myparsed));
                    currentCategory = myPrevousCategory;
                    break;

                case "TWO_PARAM_PARENTHESIS":
                // maximum of two parameters
                    myparsed = this.processExpressionList(strippedToken);

                    mylast = array_pop(myExpression);
                    mylast["length"] = myparsed[0].baseExpression;
                    mylast["decimals"] = isset(myparsed[1]) ? myparsed[1].baseExpression : false;

                   myExpression ~= mylast;
                   myExpression ~= createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                    "sub_tree" : myparsed);
                    currentCategory = myPrevousCategory;
                    break;

                case "MULTIPLE_PARAM_PARENTHESIS":
                // some parameters
                    myparsed = this.processExpressionList(strippedToken);

                    mylast = array_pop(myExpression);
                    mysubTree = createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                     "sub_tree" : myparsed];

                    if (this.options.hasConsistentSubtrees()) {
                        mysubTree = [mysubTree];
                    }

                    mylast["sub_tree"] = mysubTree;
                   myExpression ~= mylast;
                    currentCategory = myPrevousCategory;
                    break;

                default:
                    break;
                }

            }
           myPrevousCategory = currentCategory;
            currentCategory = "";
        }

        if (!myExpression.isSet("till")) {
            // end of mytokens array
           myExpression = this.buildColDef(myExpression, baseExpression.strip, myoptions, myrefs, -1);
        }
        return myExpression;
    }
}
