module langs.sql.sqlparsers.processors.sql;

import lang.sql;

@safe:
//This class processes the base SQL statements.
class SQLProcessor : SQLChunkProcessor {

    /**
     * This auto breaks up the SQL statement into logical sections. 
     * Some sections are delegated to specialized processors.
     */
    auto process( mytokens) {
        string previousCategory = "";
        string tokenCategory = "";
        myskip_next = 0;
        result  = [];

        // mytokens may come as a numeric indexed array starting with an index greater than 0 (or as a boolean)
        mytokenCount = count( mytokens);
        if (is_array( mytokens)) {
            mytokens = array_values( mytokens);
        }

        for ( mytokenNumber = 0; mytokenNumber < mytokenCount; ++ mytokenNumber) {

            // https://github.com/greenlion/PHP-SQL-Parser/issues/279
            // https://github.com/sinri/PHP-SQL-Parser/commit/eac592a0e19f1df6f420af3777a6d5504837faa7
            // as there is no pull request for 279 by the user. His solution works and tested.
            if (! mytokens.isSet( mytokenNumber)) {
                continue;
            } // as a fix by Sinri 20180528
           myToken = mytokens[ mytokenNumber];
            auto strippedToken = mytoken.strip; // this removes also \n and \t!

            // if it starts with an "(", it should follow a SELECT
            if (strippedToken != "" && strippedToken[0] == "(" && tokenCategory.isEmpty) {
                tokenCategory = "BRACKET";
                previousCategory = tokenCategory;
            }

            /*
             * If it isn"t obvious, when myskip_next is set, then we ignore the next real token, that is we ignore whitespace.
             */
            if ( myskip_next > 0) {
                if (strippedToken.isEmpty) {
                    if (tokenCategory != "") { // is this correct??
                        result [tokenCategory] ~= mytoken;
                    }
                    continue;
                }
                // to skip the token we replace it with whitespace
                strippedToken = "";
               myToken = "";
                myskip_next--;
                if ( myskip_next > 0) {
                    continue;
                }
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

                /* Tokens that get their own sections. These keywords have subclauses. */
            case "SELECT" : case "ORDER" : case "VALUES" : case "GROUP" : case "HAVING" : case "WHERE" : case "CALL"
                    : case "PROCEDURE" : case "FUNCTION" : case "SERVER" : case "LOGFILE" : case "DEFINER" : case "RETURNS"
                    : case "TABLESPACE" : case "TRIGGER" : case "DO" : case "FLUSH" : case "KILL" : case "RESET" : case "STOP"
                    : case "PURGE" : case "EXECUTE" : case "PREPARE" : tokenCategory = upperToken;
                break;

            case "DEALLOCATE" : if (strippedToken == "DEALLOCATE") {
                    myskip_next = 1;
                }
                tokenCategory = upperToken;
                break;

            case "DUPLICATE" : if (tokenCategory != "VALUES") {
                    tokenCategory = upperToken;
                }
                break;

            case "SET" : if (tokenCategory != "TABLE") {
                    tokenCategory = upperToken;
                }
                break;

            case "LIMIT" : case "PLUGIN" : // no separate section
                if (tokenCategory == "SHOW") {
                    break;
                }
                tokenCategory = upperToken;
                break;

            case "FROM" : // this FROM is different from FROM in other DML (not join related)
                if (tokenCategory == "PREPARE") {
                    continue 2;
                }
                // no separate section
                if (tokenCategory == "SHOW") {
                    break;
                }
                tokenCategory = upperToken;
                break;

            case "EXPLAIN" : case "DESCRIBE" : case "SHOW" : tokenCategory = upperToken;
                break;

            case "DESC" : if (tokenCategory.isEmpty) {
                    // short version of DESCRIBE
                    tokenCategory = upperToken;
                }
                // else direction of ORDER-BY
                break;

            case "RENAME" : tokenCategory = upperToken;
                break;

            case "DATABASE" : case "SCHEMA" : if (previousCategory == "DROP"
                    || previousCategory == "SHOW") {
                    break;
                }
                tokenCategory = upperToken;
                break;

            case "EVENT" : // issue 71
                if (previousCategory == "DROP"
                    || previousCategory == "ALTER" || previousCategory == "CREATE") {
                    tokenCategory = upperToken;
                }
                break;

            case "DATA" : // prevent wrong handling of DATA as keyword
                if (previousCategory == "LOAD") {
                    tokenCategory = upperToken;
                }
                break;

            case "INTO" : // prevent wrong handling of CACHE within LOAD INDEX INTO CACHE...
                if (previousCategory == "LOAD") {
                    result [previousCategory] ~= strippedToken;
                    continue 2;
                }
                tokenCategory = previousCategory = upperToken;
                break;

            case "USER" : // prevent wrong processing as keyword
                if (previousCategory == "CREATE" || previousCategory == "RENAME" || previousCategory == "DROP") {
                    tokenCategory = upperToken;
                }
                break;

            case "VIEW" : // prevent wrong processing as keyword
                if (previousCategory == "CREATE" || previousCategory == "ALTER" || previousCategory == "DROP") {
                    tokenCategory = upperToken;
                }
                break;

                /*
             * These tokens get their own section, but have no subclauses. These tokens identify the statement but have no specific subclauses of their own.
             */
            case "DELETE" : case "ALTER" : case "INSERT" : case "OPTIMIZE" : case "GRANT" : case "REVOKE"
                    : case "HANDLER" : case "LOAD" : case "ROLLBACK" : case "SAVEPOINT" : case "UNLOCK" : case "INSTALL"
                    : case "UNINSTALL" : case "ANALZYE" : case "BACKUP" : case "CHECKSUM"
                    : case "REPAIR" : case "RESTORE" : case "HELP" : tokenCategory = upperToken;
                // set the category in case these get subclauses in a future version of MySQL
                result [upperToken][0] = strippedToken;
                continue 2;

            case "TRUNCATE" : if (previousCategory.isEmpty) {
                    // set the category in case these get subclauses in a future version of MySQL
                    tokenCategory = upperToken;
                    result [upperToken][0] = strippedToken;
                    continue 2;
                }
                // part of the CREATE TABLE statement or a function
                result [previousCategory] ~= strippedToken;
                continue 2;

            case "REPLACE" : if (previousCategory.isEmpty) {
                    // set the category in case these get subclauses in a future version of MySQL
                    tokenCategory = upperToken;
                    result [upperToken][0] = strippedToken;
                    continue 2;
                }
                // part of the CREATE TABLE statement or a function
                result [previousCategory] ~= strippedToken;
                continue 2;

            case "IGNORE" : if (previousCategory == "TABLE") {
                    // part of the CREATE TABLE statement
                    result [previousCategory] ~= strippedToken;
                    continue 2;
                }
                if (tokenCategory == "FROM") {
                    // part of the FROM statement (index hint)
                    result [tokenCategory] ~= strippedToken;
                    continue 2;
                }
                result ["OPTIONS"] ~= upperToken;
                continue 2;

            case "CHECK" : if (previousCategory == "TABLE") {
                    result [previousCategory] ~= strippedToken;
                    continue 2;
                }
                tokenCategory = upperToken;
                result [upperToken][0] = strippedToken;
                continue 2;

            case "CREATE" : if (previousCategory == "SHOW") {
                    break;
                }
                tokenCategory = upperToken;
                break;

            case "INDEX" : if (in_array(previousCategory, ["CREATE", "DROP"))
                            ) {
                                result [previousCategory] ~= strippedToken;
                                tokenCategory = upperToken;
                            }
                            break;

            case "TABLE": if (previousCategory == "CREATE") {
                                result [previousCategory] ~= strippedToken;
                                tokenCategory = upperToken;
                            }
                            if (previousCategory == "TRUNCATE") {
                                result [previousCategory] ~= strippedToken;
                                tokenCategory = upperToken;
                            }
                            break;

            case "TEMPORARY": if (previousCategory == "CREATE") {
                                result [previousCategory] ~= strippedToken;
                                tokenCategory = previousCategory;
                                continue 2;
                            }
                            break;

            case "IF": if (previousCategory == "TABLE") {
                                tokenCategory = "CREATE";
                                result [tokenCategory] = array_merge(result [tokenCategory], result [previousCategory]);
                                result [previousCategory] = [];
                                result [tokenCategory] ~= strippedToken;
                                previousCategory = tokenCategory;
                                continue 2;
                            }
                            break;

            case "NOT": if (previousCategory == "CREATE") {
                                tokenCategory = previousCategory;
                                result [previousCategory] ~= strippedToken;
                                continue 2;
                            }
                            break;

            case "EXISTS": if (previousCategory == "CREATE") {
                                result [previousCategory] ~= strippedToken;
                                previousCategory = tokenCategory = "TABLE";
                                continue 2;
                            }
                            break;

            case "CACHE": if (previousCategory.isEmpty || previousCategory == "RESET" || previousCategory == "FLUSH"
                            || previousCategory == "LOAD") {
                                tokenCategory = upperToken;
                                continue 2;
                            }
                            break;

                            /* This is either LOCK TABLES or SELECT ... LOCK IN SHARE MODE */
            case "LOCK": if (tokenCategory.isEmpty) {
                                tokenCategory = upperToken;
                                result [upperToken][0] = strippedToken;
                            } else if (tokenCategory == "INDEX") {
                                break;
                            } else {
                                strippedToken = "LOCK IN SHARE MODE";
                                myskip_next = 3;
                                result ["OPTIONS"] ~= strippedToken;
                            }
                            continue 2;

            case "USING":  /* USING in FROM clause is different from USING w/ prepared statement*/
                            if (tokenCategory == "EXECUTE") {
                                tokenCategory = upperToken;
                                continue 2;
                            }
                            if (tokenCategory == "FROM" && !result ["DELETE"].isEmpty) {
                                tokenCategory = upperToken;
                                continue 2;
                            }
                            break;

                            /* DROP TABLE is different from ALTER TABLE DROP ... */
            case "DROP": if (tokenCategory != "ALTER") {
                                tokenCategory = upperToken;
                                continue 2;
                            }
                            break;

            case "FOR": if (previousCategory == "SHOW" || tokenCategory == "FROM") {
                                break;
                            }
                            myskip_next = 1;
                            result ["OPTIONS"] ~= "FOR UPDATE"; // TODO: this could be generate problems within the position calculator
                            continue 2;

            case "UPDATE": if (tokenCategory.isEmpty) {
                                tokenCategory = upperToken;
                                continue 2;
                            }
                            if (tokenCategory == "DUPLICATE") {
                                continue 2;
                            }
                            break;

            case "START": strippedToken = "BEGIN";
                            result [upperToken][0] = upperToken; // TODO: this could be generate problems within the position calculator
                            myskip_next = 1;
                            break;

                            // This token is ignored, except within RENAME
            case "TO": if (tokenCategory == "RENAME") {
                                break;
                            }
                            continue 2;

                            // This token is ignored, except within CREATE TABLE
            case "BY": if (previousCategory == "TABLE") {
                                break;
                            }
                            continue 2;

                            // These tokens are ignored.
            case "ALL": case "SHARE": case "MODE": case ";": continue 2;

            case "KEY": if (tokenCategory == "DUPLICATE") {
                                continue 2;
                            }
                            break;

                            /* These tokens set particular options for the statement. */
            case "LOW_PRIORITY": case "DELAYED": case "QUICK": case "HIGH_PRIORITY": result ["OPTIONS"] ~= strippedToken;
                            continue 2;

            case "USE": if (tokenCategory == "FROM") {
                                // index hint within FROM clause
                                result [tokenCategory] ~= strippedToken;
                                continue 2;
                            }
                            // set the category in case these get subclauses in a future version of MySQL
                            tokenCategory = upperToken;
                            result [upperToken][0] = strippedToken;
                            continue 2;

            case "FORCE": if (tokenCategory == "FROM") {
                                // index hint within FROM clause
                                result [tokenCategory] ~= strippedToken;
                                continue 2;
                            }
                            result ["OPTIONS"] ~= strippedToken;
                            continue 2;

            case "WITH": if (tokenCategory == "GROUP") {
                                myskip_next = 1;
                                result ["OPTIONS"] ~= "WITH ROLLUP"; // TODO: this could be generate problems within the position calculator
                                continue 2;
                            }
                            if (tokenCategory.isEmpty) {
                                tokenCategory = upperToken;
                            }
                            break;

            case "AS": break;

            case "": case ",": break;

            default: break;
                            }

                            // remove obsolete category after union (empty category because of
                            // empty token before select)
                            if (tokenCategory != "" && (previousCategory == tokenCategory)) {
                                result [tokenCategory] ~= mytoken;
                            }

                            previousCategory = tokenCategory;
                            }

                            if (count(result ) == 0) {
                                return false;
                            }

                            return super.process(result );
                            }
                            }
