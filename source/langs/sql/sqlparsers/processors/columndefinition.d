
module langs.sql.PHPSQLParser.processors.columndefinition;

import lang.sql;

@safe:

/**
 * This file : the processor for column definition part of a CREATE TABLE statement.
 * This class processes the column definition part of a CREATE TABLE statement.
 * */
class ColumnDefinitionProcessor : AbstractProcessor {

    protected auto processExpressionList($parsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        myExpression = this.removeParenthesisFromStart($parsed);
        myExpression = this.splitSQLIntoTokens(myExpression);
        myExpression = this.removeComma(myExpression);
        return myProcessor.process(myExpression);
    }

    protected auto processReferenceDefinition($parsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto removeComma($tokens) {
        $res = [];
        foreach (myToken; $tokens) {
            if (myToken.strip != ",") {
                $res[] = myToken;
            }
        }
        return $res;
    }

    protected auto buildColDef(myExpression, baseExpression, $options, $refs, myKey) {
        myExpression = ["expr_type" : expressionType("COLUMN_TYPE"), "base_expr" : baseExpression, "sub_tree" : myExpression];

        // add options first
        myExpression["sub_tree"] = array_merge(myExpression["sub_tree"], $options["sub_tree"]);
        unset($options["sub_tree"]);
        myExpression = array_merge(myExpression, $options);

        // followed by references
        if (sizeof($refs) != 0) {
            myExpression["sub_tree"] = array_merge(myExpression["sub_tree"], $refs);
        }

        myExpression["till"] = myKey;
        return myExpression;
    }

    auto process($tokens) {
        string baseExpression = "";
        string currentCategory = "";
        myExpression = [];
        $refs = [];
        $options = ['unique' : false, 'nullable' : true, 'auto_inc' : false, 'primary' : false,
                         "sub_tree" : []);
        $skip = 0;

        foreach (myKey, myToken; $tokens) {

            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
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
                myExpression = this.buildColDef(myExpression, (substr(baseExpression, 0, -myToken.length)).strip, $options, $refs,
                    myKey - 1);
                break 2;

            case 'VARCHAR':
            case 'VARCHARACTER': // Alias for VARCHAR
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'length' : false];
                $prevCategory = 'TEXT';
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                continue 2;

            case 'VARBINARY':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'length' : false];
                $prevCategory = upperToken;
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                continue 2;

            case 'UNSIGNED':
                foreach (array_reverse(array_keys(myExpression)) as $i) {
                    if (myExpression[$i].isSet("expr_type") && (expressionType("DATA_TYPE") == myExpression[$i]["expr_type"])) {
                        myExpression[$i]["unsigned"] = true;
                        break;
                    }
                }
	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'ZEROFILL':
                $last = array_pop(myExpression);
                $last["zerofill"] = true;
                myExpression[] = $last;
	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'BIT':
            case 'TINYBIT':
            case 'TINYINT':
            case 'SMALLINT':
            case 'INT2':       // Alias of SMALLINT
            case 'MEDIUMINT':
            case 'INT3':       // Alias of MEDIUMINT
            case 'MIDDLEINT':  // Alias of MEDIUMINT
            case 'INT':
            case 'INTEGER':
            case 'INT4':       // Alias of INT
            case 'BIGINT':
            case 'INT8':       // Alias of BIGINT
            case 'BOOL':
            case 'BOOLEAN':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'unsigned' : false,
                                'zerofill' : false, 'length' : false];
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = upperToken;
                continue 2;

            case 'BINARY':
                if (currentCategory == 'TEXT') {
                    $last = array_pop(myExpression);
                    $last["binary"] = true;
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = $last;
                    continue 2;
                }
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'length' : false];
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = upperToken;
                continue 2;

            case 'CHAR':
            case 'CHARACTER':  // Alias for CHAR
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'length' : false];
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = 'TEXT';
                continue 2;

            case 'REAL':
            case 'DOUBLE':
            case 'FLOAT8':     // Alias for DOUBLE
            case 'FLOAT':
            case 'FLOAT4':     // Alias for FLOAT
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'unsigned' : false,
                                'zerofill' : false];
                currentCategory = 'TWO_PARAM_PARENTHESIS';
                $prevCategory = upperToken;
                continue 2;

            case 'DECIMAL':
            case 'NUMERIC':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'unsigned' : false,
                                'zerofill' : false];
                currentCategory = 'TWO_PARAM_PARENTHESIS';
                $prevCategory = upperToken;
                continue 2;

            case 'YEAR':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'length' : false];
                currentCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = upperToken;
                continue 2;

            case 'DATE':
            case 'TIME':
            case 'TIMESTAMP':
            case 'DATETIME':
            case 'TINYBLOB':
            case 'BLOB':
            case 'MEDIUMBLOB':
            case 'LONGBLOB':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr": strippedToken];
                $prevCategory = currentCategory = upperToken;
                continue 2;

            // the next token can be BINARY
            case 'TINYTEXT':
            case 'TEXT':
            case 'MEDIUMTEXT':
            case 'LONGTEXT':
                $prevCategory = currentCategory = 'TEXT';
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr" : strippedToken, 'binary' : false];
                continue 2;

            case 'ENUM':
                currentCategory = 'MULTIPLE_PARAM_PARENTHESIS';
                $prevCategory = 'TEXT';
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken, "sub_tree" : false];
                continue 2;

            case 'GEOMETRY':
            case 'POINT':
            case 'LINESTRING':
            case 'POLYGON':
            case 'MULTIPOINT':
            case 'MULTILINESTRING':
            case 'MULTIPOLYGON':
            case 'GEOMETRYCOLLECTION':
                myExpression[] = ["expr_type" : expressionType("DATA_TYPE"), "base_expr": strippedToken];
                $prevCategory = currentCategory = upperToken;
                // TODO: is it right?
                // spatial types
                continue 2;

            case 'CHARACTER':
                currentCategory = 'CHARSET';
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'SET':
				if (currentCategory == 'CHARSET') {
    	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
				} else {
	                currentCategory = 'MULTIPLE_PARAM_PARENTHESIS';
    	            $prevCategory = 'TEXT';
        	        myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken, "sub_tree" : false];
				}
                continue 2;

            case 'COLLATE':
                currentCategory = upperToken;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'NOT':
            case 'NULL':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                if ($options["nullable"]) {
                    $options["nullable"] = (upperToken == 'NOT' ? false : true);
                }
                continue 2;

            case 'DEFAULT':
            case 'COMMENT':
                currentCategory = upperToken;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'AUTO_INCREMENT':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                $options["auto_inc"] = true;
                continue 2;

            case 'COLUMN_FORMAT':
            case 'STORAGE':
                currentCategory = upperToken;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'UNIQUE':
            // it can follow a KEY word
                currentCategory = upperToken;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                $options["unique"] = true;
                continue 2;

            case 'PRIMARY':
            // it must follow a KEY word
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                continue 2;

            case 'KEY':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                if (currentCategory != 'UNIQUE') {
                    $options["primary"] = true;
                }
                continue 2;

            case 'REFERENCES':
                $refs = this.processReferenceDefinition(array_splice($tokens, myKey - 1, null, true));
                $skip = $refs["till"] - myKey;
                unset($refs["till"]);
                // TODO: check this, we need the last comma
                continue 2;

            default:
                switch (currentCategory) {

                case 'STORAGE':
                    if (upperToken == 'DISK' || upperToken == 'MEMORY' || upperToken == 'DEFAULT') {
                        $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                        $options["storage"] = strippedToken;
                        continue 3;
                    }
                    // else ?
                    break;

                case 'COLUMN_FORMAT':
                    if (upperToken == 'FIXED' || upperToken == 'DYNAMIC' || upperToken == 'DEFAULT') {
                        $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                        $options["col_format"] = strippedToken;
                        continue 3;
                    }
                    // else ?
                    break;

                case 'COMMENT':
                // this is the comment string
                    $options["sub_tree"][] = ["expr_type" : expressionType(COMMENT, "base_expr": strippedToken];
                    $options["comment"] = strippedToken;
                    currentCategory = $prevCategory;
                    break;

                case 'DEFAULT':
                // this is the default value
                    $options["sub_tree"][] = ["expr_type" : expressionType(DEF_VALUE, "base_expr": strippedToken];
                    $options["default"] = strippedToken;
                    currentCategory = $prevCategory;
                    break;

                case 'COLLATE':
                // this is the collation name
                    $options["sub_tree"][] = ["expr_type" : expressionType(COLLATE, "base_expr": strippedToken];
                    $options["collate"] = strippedToken;
                    currentCategory = $prevCategory;
                    break;

                case 'CHARSET':
                // this is the character set name
                    $options["sub_tree"][] = ["expr_type" : expressionType(CHARSET, "base_expr": strippedToken];
                    $options["charset"] = strippedToken;
                    currentCategory = $prevCategory;
                  break;

                case 'SINGLE_PARAM_PARENTHESIS':
                    $parsed = this.removeParenthesisFromStart(strippedToken);
                    $parsed = ["expr_type" : expressionType(CONSTANT, "base_expr" : trim($parsed));
                    $last = array_pop(myExpression);
                    $last["length"] = $parsed["base_expr"];

                    myExpression[] = $last;
                    myExpression[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : strippedToken,
                                    "sub_tree" : [$parsed));
                    currentCategory = $prevCategory;
                    break;

                case 'TWO_PARAM_PARENTHESIS':
                // maximum of two parameters
                    $parsed = this.processExpressionList(strippedToken);

                    $last = array_pop(myExpression);
                    $last["length"] = $parsed[0]["base_expr"];
                    $last["decimals"] = isset($parsed[1]) ? $parsed[1]["base_expr"] : false;

                    myExpression[] = $last;
                    myExpression[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : strippedToken,
                                    "sub_tree" : $parsed);
                    currentCategory = $prevCategory;
                    break;

                case 'MULTIPLE_PARAM_PARENTHESIS':
                // some parameters
                    $parsed = this.processExpressionList(strippedToken);

                    $last = array_pop(myExpression);
                    $subTree = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : strippedToken,
                                     "sub_tree" : $parsed);

                    if (this.options.getConsistentSubtrees()) {
                        $subTree = [$subTree);
                    }

                    $last["sub_tree"] = $subTree;
                    myExpression[] = $last;
                    currentCategory = $prevCategory;
                    break;

                default:
                    break;
                }

            }
            $prevCategory = currentCategory;
            currentCategory = "";
        }

        if (!isset(myExpression["till"])) {
            // end of $tokens array
            myExpression = this.buildColDef(myExpression, baseExpression.strip, $options, $refs, -1);
        }
        return myExpression;
    }
}
