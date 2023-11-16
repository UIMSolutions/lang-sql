
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
        $expr = this.removeParenthesisFromStart($parsed);
        $expr = this.splitSQLIntoTokens($expr);
        $expr = this.removeComma($expr);
        return myProcessor.process($expr);
    }

    protected auto processReferenceDefinition($parsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto removeComma($tokens) {
        $res = [];
        foreach ($token; $tokens) {
            if ($token.strip != ',') {
                $res[] = $token;
            }
        }
        return $res;
    }

    protected auto buildColDef($expr, $base_expr, $options, $refs, $key) {
        $expr = ["expr_type" : expressionType(COLUMN_TYPE, "base_expr" : $base_expr, "sub_tree" : $expr];

        // add options first
        $expr["sub_tree"] = array_merge($expr["sub_tree"], $options["sub_tree"]);
        unset($options["sub_tree"]);
        $expr = array_merge($expr, $options);

        // followed by references
        if (sizeof($refs) != 0) {
            $expr["sub_tree"] = array_merge($expr["sub_tree"], $refs);
        }

        $expr["till"] = $key;
        return $expr;
    }

    auto process($tokens) {

        $trim = "";
        $base_expr = "";
        $currCategory = "";
        $expr = [];
        $refs = [];
        $options = ['unique' : false, 'nullable' : true, 'auto_inc' : false, 'primary' : false,
                         "sub_tree" : []);
        $skip = 0;

        foreach ($tokens as $key : $token) {

            $trim = $token.strip;
            $base_expr  ~= $token;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if ($trim.isEmpty) {
                continue;
            }

            $upper = $trim.toUpper;

            switch ($upper) {

            case ',':
            // we stop on a single comma and return
            // the $expr entry and the index $key
                $expr = this.buildColDef($expr, trim(substr($base_expr, 0, -$token.length)), $options, $refs,
                    $key - 1);
                break 2;

            case 'VARCHAR':
            case 'VARCHARACTER': // Alias for VARCHAR
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'length' : false);
                $prevCategory = 'TEXT';
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                continue 2;

            case 'VARBINARY':
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'length' : false);
                $prevCategory = $upper;
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                continue 2;

            case 'UNSIGNED':
                foreach (array_reverse(array_keys($expr)) as $i) {
                    if (isset($expr[$i]["expr_type"]) && (expressionType(DATA_TYPE == $expr[$i]["expr_type"])) {
                        $expr[$i]["unsigned"] = true;
                        break;
                    }
                }
	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'ZEROFILL':
                $last = array_pop($expr);
                $last["zerofill"] = true;
                $expr[] = $last;
	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
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
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'unsigned' : false,
                                'zerofill' : false, 'length' : false);
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = $upper;
                continue 2;

            case 'BINARY':
                if ($currCategory == 'TEXT') {
                    $last = array_pop($expr);
                    $last["binary"] = true;
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                    $expr[] = $last;
                    continue 2;
                }
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'length' : false);
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = $upper;
                continue 2;

            case 'CHAR':
            case 'CHARACTER':  // Alias for CHAR
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'length' : false);
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = 'TEXT';
                continue 2;

            case 'REAL':
            case 'DOUBLE':
            case 'FLOAT8':     // Alias for DOUBLE
            case 'FLOAT':
            case 'FLOAT4':     // Alias for FLOAT
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'unsigned' : false,
                                'zerofill' : false);
                $currCategory = 'TWO_PARAM_PARENTHESIS';
                $prevCategory = $upper;
                continue 2;

            case 'DECIMAL':
            case 'NUMERIC':
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'unsigned' : false,
                                'zerofill' : false);
                $currCategory = 'TWO_PARAM_PARENTHESIS';
                $prevCategory = $upper;
                continue 2;

            case 'YEAR':
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'length' : false);
                $currCategory = 'SINGLE_PARAM_PARENTHESIS';
                $prevCategory = $upper;
                continue 2;

            case 'DATE':
            case 'TIME':
            case 'TIMESTAMP':
            case 'DATETIME':
            case 'TINYBLOB':
            case 'BLOB':
            case 'MEDIUMBLOB':
            case 'LONGBLOB':
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr": $trim];
                $prevCategory = $currCategory = $upper;
                continue 2;

            // the next token can be BINARY
            case 'TINYTEXT':
            case 'TEXT':
            case 'MEDIUMTEXT':
            case 'LONGTEXT':
                $prevCategory = $currCategory = 'TEXT';
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr" : $trim, 'binary' : false);
                continue 2;

            case 'ENUM':
                $currCategory = 'MULTIPLE_PARAM_PARENTHESIS';
                $prevCategory = 'TEXT';
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim, "sub_tree" : false);
                continue 2;

            case 'GEOMETRY':
            case 'POINT':
            case 'LINESTRING':
            case 'POLYGON':
            case 'MULTIPOINT':
            case 'MULTILINESTRING':
            case 'MULTIPOLYGON':
            case 'GEOMETRYCOLLECTION':
                $expr[] = ["expr_type" : expressionType(DATA_TYPE, "base_expr": $trim];
                $prevCategory = $currCategory = $upper;
                // TODO: is it right?
                // spatial types
                continue 2;

            case 'CHARACTER':
                $currCategory = 'CHARSET';
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'SET':
				if ($currCategory == 'CHARSET') {
    	            $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
				} else {
	                $currCategory = 'MULTIPLE_PARAM_PARENTHESIS';
    	            $prevCategory = 'TEXT';
        	        $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim, "sub_tree" : false);
				}
                continue 2;

            case 'COLLATE':
                $currCategory = $upper;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'NOT':
            case 'NULL':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                if ($options["nullable"]) {
                    $options["nullable"] = ($upper == 'NOT' ? false : true);
                }
                continue 2;

            case 'DEFAULT':
            case 'COMMENT':
                $currCategory = $upper;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'AUTO_INCREMENT':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                $options["auto_inc"] = true;
                continue 2;

            case 'COLUMN_FORMAT':
            case 'STORAGE':
                $currCategory = $upper;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'UNIQUE':
            // it can follow a KEY word
                $currCategory = $upper;
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                $options["unique"] = true;
                continue 2;

            case 'PRIMARY':
            // it must follow a KEY word
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                continue 2;

            case 'KEY':
                $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                if ($currCategory != 'UNIQUE') {
                    $options["primary"] = true;
                }
                continue 2;

            case 'REFERENCES':
                $refs = this.processReferenceDefinition(array_splice($tokens, $key - 1, null, true));
                $skip = $refs["till"] - $key;
                unset($refs["till"]);
                // TODO: check this, we need the last comma
                continue 2;

            default:
                switch ($currCategory) {

                case 'STORAGE':
                    if ($upper == 'DISK' || $upper == 'MEMORY' || $upper == 'DEFAULT') {
                        $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                        $options["storage"] = $trim;
                        continue 3;
                    }
                    // else ?
                    break;

                case 'COLUMN_FORMAT':
                    if ($upper == 'FIXED' || $upper == 'DYNAMIC' || $upper == 'DEFAULT') {
                        $options["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                        $options["col_format"] = $trim;
                        continue 3;
                    }
                    // else ?
                    break;

                case 'COMMENT':
                // this is the comment string
                    $options["sub_tree"][] = ["expr_type" : expressionType(COMMENT, "base_expr": $trim];
                    $options["comment"] = $trim;
                    $currCategory = $prevCategory;
                    break;

                case 'DEFAULT':
                // this is the default value
                    $options["sub_tree"][] = ["expr_type" : expressionType(DEF_VALUE, "base_expr": $trim];
                    $options["default"] = $trim;
                    $currCategory = $prevCategory;
                    break;

                case 'COLLATE':
                // this is the collation name
                    $options["sub_tree"][] = ["expr_type" : expressionType(COLLATE, "base_expr": $trim];
                    $options["collate"] = $trim;
                    $currCategory = $prevCategory;
                    break;

                case 'CHARSET':
                // this is the character set name
                    $options["sub_tree"][] = ["expr_type" : expressionType(CHARSET, "base_expr": $trim];
                    $options["charset"] = $trim;
                    $currCategory = $prevCategory;
                  break;

                case 'SINGLE_PARAM_PARENTHESIS':
                    $parsed = this.removeParenthesisFromStart($trim);
                    $parsed = ["expr_type" : expressionType(CONSTANT, "base_expr" : trim($parsed));
                    $last = array_pop($expr);
                    $last["length"] = $parsed["base_expr"];

                    $expr[] = $last;
                    $expr[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $trim,
                                    "sub_tree" : [$parsed));
                    $currCategory = $prevCategory;
                    break;

                case 'TWO_PARAM_PARENTHESIS':
                // maximum of two parameters
                    $parsed = this.processExpressionList($trim);

                    $last = array_pop($expr);
                    $last["length"] = $parsed[0]["base_expr"];
                    $last["decimals"] = isset($parsed[1]) ? $parsed[1]["base_expr"] : false;

                    $expr[] = $last;
                    $expr[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $trim,
                                    "sub_tree" : $parsed);
                    $currCategory = $prevCategory;
                    break;

                case 'MULTIPLE_PARAM_PARENTHESIS':
                // some parameters
                    $parsed = this.processExpressionList($trim);

                    $last = array_pop($expr);
                    $subTree = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $trim,
                                     "sub_tree" : $parsed);

                    if (this.options.getConsistentSubtrees()) {
                        $subTree = [$subTree);
                    }

                    $last["sub_tree"] = $subTree;
                    $expr[] = $last;
                    $currCategory = $prevCategory;
                    break;

                default:
                    break;
                }

            }
            $prevCategory = $currCategory;
            $currCategory = "";
        }

        if (!isset($expr["till"])) {
            // end of $tokens array
            $expr = this.buildColDef($expr, trim($base_expr), $options, $refs, -1);
        }
        return $expr;
    }
}
