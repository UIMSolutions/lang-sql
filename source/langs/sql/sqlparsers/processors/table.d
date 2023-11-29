module langs.sql.sqlparsers.processors.table;

import lang.sql;

@safe:

// This class processes the TABLE statements.
class TableProcessor : AbstractProcessor {

    protected auto getReservedType(myToken) {
        return createExpression("RESERVED"), "base_expr" :  mytoken];
    }

    protected auto getConstantType( mytoken) {
        return createExpression("CONSTANT"), "base_expr" :  mytoken];
    }

    protected auto getOperatorType( mytoken) {
        return createExpression("OPERATOR"), "base_expr" :  mytoken];
    }

    protected auto processPartitionOptions( mytokens) {
        auto myProcessor = new PartitionOptionsProcessor(this.options);
        return myProcessor.process( mytokens);
    }

    protected auto processCreateDefinition( mytokens) {
        auto myProcessor = new CreateDefinitionProcessor(this.options);
        return myProcessor.process( mytokens);
    }

    protected auto clear(&myExpression, &baseExpression, & mycategory) {
        myExpression = [];
        baseExpression = "";
         mycategory = "CREATE_DEF";
    }

    auto process( mytokens) {

        currentCategory = "TABLE_NAME";
         myresult = ["base_expr" : false, "name" : false, "no_quotes" : false, "create-def" : false,
                        "options" : [], "like" : false, "select-option" : false];
        myExpression = [];
        baseExpression = "";
         myskip = 0;

        foreach ( mytokenKey : myToken;  mytokens) {
            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if ( myskip > 0) {
                 myskip--;
                continue;
            }

            if ( myskip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case ",":
            // it is possible to separate the table options with comma!
                if ( myprevCategory == "CREATE_DEF") {
                     mylast = array_pop( myresult["options"]);
                     mylast["delim"] = ",";
                     myresult["options"] ~=  mylast;
                    baseExpression = "";
                }
                continue 2;

            case "UNION":
                if ( myprevCategory == "CREATE_DEF") {
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "UNION";
                    continue 2;
                }
                break;

            case "LIKE":
            // like without parenthesis
                if ( myprevCategory == "TABLE_NAME") {
                    currentCategory = upperToken;
                    continue 2;
                }
                break;

            case "=":
            // the optional operator
                if ( myprevCategory == "TABLE_OPTION") {
                    myExpression ~= this.getOperatorType(strippedToken);
                    continue 2; // don"t change the category
                }
                break;

            case "CHARACTER":
                if ( myprevCategory == "CREATE_DEF") {
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "TABLE_OPTION";
                }
                if ( myprevCategory == "TABLE_OPTION") {
                    // add it to the previous DEFAULT
                    myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "SET":
            case "CHARSET":
                if ( myprevCategory == "TABLE_OPTION") {
                    // add it to a previous CHARACTER
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "CHARSET";
                    continue 2;
                }
                break;

            case "COLLATE":
                if ( myprevCategory == "TABLE_OPTION" ||  myprevCategory == "CREATE_DEF") {
                    // add it to the previous DEFAULT
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "COLLATE";
                    continue 2;
                }
                break;

            case "DIRECTORY":
                if (currentCategory == "INDEX_DIRECTORY" || currentCategory == "DATA_DIRECTORY") {
                    // after INDEX or DATA
                    myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "INDEX":
                if ( myprevCategory == "CREATE_DEF") {
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "INDEX_DIRECTORY";
                    continue 2;
                }
                break;

            case "DATA":
                if ( myprevCategory == "CREATE_DEF") {
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "DATA_DIRECTORY";
                    continue 2;
                }
                break;

            case "INSERT_METHOD":
            case "DELAY_KEY_WRITE":
            case "ROW_FORMAT":
            case "PASSWORD":
            case "MAX_ROWS":
            case "MIN_ROWS":
            case "PACK_KEYS":
            case "CHECKSUM":
            case "COMMENT":
            case "CONNECTION":
            case "AUTO_INCREMENT":
            case "AVG_ROW_LENGTH":
            case "ENGINE":
            case "TYPE":
            case "STATS_AUTO_RECALC":
            case "STATS_PERSISTENT":
            case "KEY_BLOCK_SIZE":
                if ( myprevCategory == "CREATE_DEF") {
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory =  myprevCategory = "TABLE_OPTION";
                    continue 2;
                }
                break;

            case "DYNAMIC":
            case "FIXED":
            case "COMPRESSED":
            case "REDUNDANT":
            case "COMPACT":
            case "NO":
            case "FIRST":
            case "LAST":
            case "DEFAULT":
                if ( myprevCategory == "CREATE_DEF") {
                    // DEFAULT before CHARACTER SET and COLLATE
                    myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = "TABLE_OPTION";
                }
                if ( myprevCategory == "TABLE_OPTION") {
                    // all assignments with the keywords
                    myExpression ~= this.getReservedType(strippedToken);
                     myresult["options"] ~= createExpression("EXPRESSION"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                }
                break;

            case "IGNORE":
            case "REPLACE":
                myExpression ~= this.getReservedType(strippedToken);
                 myresult["select-option"] = ["base_expr" : baseExpression.strip, "duplicates" : strippedToken, "as" : false,
                                                 "sub_tree" : myExpression];
                continue 2;

            case "AS":
                myExpression ~= this.getReservedType(strippedToken);
                if (!isset( myresult["select-option"]["duplicates"])) {
                     myresult["select-option"]["duplicates"] = false;
                }
                 myresult["select-option"]["as"] = true;
                 myresult["select-option"]["base_expr"] = baseExpression.strip;
                 myresult["select-option"]["sub_tree"] = myExpression;
                continue 2;

            case "PARTITION":
                if ( myprevCategory == "CREATE_DEF") {
                     mypart = this.processPartitionOptions(array_slice( mytokens,  mytokenKey - 1, null, true));
                     myskip =  mypart["last-parsed"] -  mytokenKey;
                     myresult["partition-options"] =  mypart["partition-options"];
                    continue 2;
                }
                // else
                break;

            default:
                switch (currentCategory) {

                case "CHARSET":
                // the charset name
                    myExpression ~= this.getConstantType(strippedToken);
                     myresult["options"] ~= createExpression("CHARSET"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "COLLATE":
                // the collate name
                    myExpression ~= this.getConstantType(strippedToken);
                     myresult["options"] ~= createExpression("COLLATE"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "DATA_DIRECTORY":
                // we have the directory name
                    myExpression ~= this.getConstantType(strippedToken);
                     myresult["options"] ~= createExpression("DIRECTORY"), "kind" : "DATA",
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression,  myprevCategory);
                    continue 3;

                case "INDEX_DIRECTORY":
                // we have the directory name
                    myExpression ~= this.getConstantType(strippedToken);
                     myresult["options"] ~= createExpression("DIRECTORY"), "kind" : "INDEX",
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression,  myprevCategory);
                    continue 3;

                case "TABLE_NAME":
                     myresult["base_expr"] =  myresult["name"] = strippedToken;
                     myresult["no_quotes"] = this.revokeQuotation(strippedToken);
                    this.clear(myExpression, baseExpression,  myprevCategory);
                    break;

                case "LIKE":
                     myresult["like"] = createExpression("TABLE"), "table" : strippedToken,
                                            "base_expr" : strippedToken, "no_quotes" : this.revokeQuotation(strippedToken));
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "":
                // after table name
                    if ( myprevCategory == "TABLE_NAME" && upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                         myunparsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                         mycoldef = this.processCreateDefinition( myunparsed);
                         myresult["create-def"] = createExpression("BRACKET_EXPRESSION"),
                                                      "base_expr" : baseExpression, "sub_tree" :  mycoldef["create-def"]);
                        myExpression = [];
                        baseExpression = "";
                        currentCategory = "CREATE_DEF";
                    }
                    break;

                case "UNION":
                // TODO: this token starts and ends with parenthesis
                // and contains a list of table names (comma-separated)
                // split the token and add the list as subtree
                // we must change the DefaultProcessor

                     myunparsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                    myExpression ~= createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                    "sub_tree" : "***TODO***");
                     myresult["options"] ~= createExpression(UNION, "base_expr" : baseExpression.strip,
                                                 "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                default:
                // strings and numeric constants
                    myExpression ~= this.getConstantType(strippedToken);
                     myresult["options"] ~= createExpression("EXPRESSION"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;
                }
                break;
            }

             myprevCategory = currentCategory;
            currentCategory = "";
        }

        if ( myresult["like"] == false) {
            unset( myresult["like"]);
        }
        if ( myresult["select-option"].isEmpty) {
            unset( myresult["select-option"]);
        }
        if ( myresult["options"] == []) {
             myresult["options"] = false;
        }

        return  myresult;
    }
}