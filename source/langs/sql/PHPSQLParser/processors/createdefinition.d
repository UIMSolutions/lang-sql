
/**
 * CreateDefinitionProcessor.php
 *
 * This file : the processor for the create definition within the TABLE statements.
 */

module langs.sql.PHPSQLParser.processors.createdefinition;

import lang.sql;

@safe:

/**
 * This class processes the create definition of the TABLE statements.
 */
class CreateDefinitionProcessor : AbstractProcessor {

    protected auto processExpressionList($parsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processIndexColumnList($parsed) {
        auto myProcessor = new IndexColumnListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processColumnDefinition($parsed) {
        auto myProcessor = new ColumnDefinitionProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processReferenceDefinition($parsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessorr.process($parsed);
    }

    protected auto correctExpressionType(&$expr) {
        $type .isExpressionType(EXPRESSION;
        if (!isset($expr[0]) || !isset($expr[0]["expr_type"])) {
            return $type;
        }

        // replace the constraint type with a more descriptive one
        switch ($expr[0]["expr_type"]) {

        case expressionType(CONSTRAINT:
            $type = $expr[1]["expr_type"];
            $expr[1]["expr_type"] .isExpressionType(RESERVED;
            break;

        case expressionType(COLREF:
            $type .isExpressionType(COLDEF;
            break;

        default:
            $type = $expr[0]["expr_type"];
            $expr[0]["expr_type"] .isExpressionType(RESERVED;
            break;

        }
        return $type;
    }

    auto process($tokens) {

        baseExpression = "";
        $prevCategory = "";
        $currCategory = "";
        $expr = [];
        $result = [];
        $skip = 0;

        foreach ($tokens as $k : $token) {

            auto strippedToken = $token.strip;
            baseExpression  ~= $token;

            if ($skip != 0) {
                $skip--;
                continue;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case 'CONSTRAINT':
                $expr[] = ["expr_type" : expressionType(CONSTRAINT, "base_expr" : strippedToken, "sub_tree" : false);
                $currCategory = $prevCategory = upperToken;
                continue 2;

            case 'LIKE':
                $expr[] = ["expr_type" : expressionType(LIKE, "base_expr": strippedToken];
                $currCategory = $prevCategory = upperToken;
                continue 2;

            case 'FOREIGN':
                if ($prevCategory.isEmpty || $prevCategory == 'CONSTRAINT') {
                    $expr[] = ["expr_type" : expressionType(FOREIGN_KEY, "base_expr": strippedToken];
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'PRIMARY':
                if ($prevCategory.isEmpty || $prevCategory == 'CONSTRAINT') {
                    // next one is KEY
                    $expr[] = ["expr_type" : expressionType(PRIMARY_KEY, "base_expr": strippedToken];
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'UNIQUE':
                if ($prevCategory.isEmpty || $prevCategory == 'CONSTRAINT' || $prevCategory == 'INDEX_COL_LIST') {
                    // next one is KEY
                    $expr[] = ["expr_type" : expressionType(UNIQUE_IDX, "base_expr": strippedToken];
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'KEY':
            // the next one is an index name
                if ($currCategory == 'PRIMARY' || $currCategory == 'FOREIGN' || $currCategory == 'UNIQUE') {
                    $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    continue 2;
                }
                $expr[] = ["expr_type" : expressionType(INDEX, "base_expr": strippedToken];
                $currCategory = upperToken;
                continue 2;

            case 'CHECK':
                $expr[] = ["expr_type" : expressionType(CHECK, "base_expr": strippedToken];
                $currCategory = upperToken;
                continue 2;

            case 'INDEX':
                if ($currCategory == 'UNIQUE' || $currCategory == 'FULLTEXT' || $currCategory == 'SPATIAL') {
                    $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    continue 2;
                }
                $expr[] = ["expr_type" : expressionType(INDEX, "base_expr": strippedToken];
                $currCategory = upperToken;
                continue 2;

            case 'FULLTEXT':
                $expr[] = ["expr_type" : expressionType(FULLTEXT_IDX, "base_expr": strippedToken];
                $currCategory = $prevCategory = upperToken;
                continue 2;

            case 'SPATIAL':
                $expr[] = ["expr_type" : expressionType(SPATIAL_IDX, "base_expr": strippedToken];
                $currCategory = $prevCategory = upperToken;
                continue 2;

            case 'WITH':
            // starts an index option
                if ($currCategory == 'INDEX_COL_LIST') {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = ["expr_type" : expressionType(INDEX_PARSER,
                                    "base_expr" : substr(baseExpression, 0, -$token.length),
                                    "sub_tree" : [$option));
                    baseExpression = $token;
                    $currCategory = 'INDEX_PARSER';
                    continue 2;
                }
                break;

            case 'KEY_BLOCK_SIZE':
            // starts an index option
                if ($currCategory == 'INDEX_COL_LIST') {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = ["expr_type" : expressionType(INDEX_SIZE,
                                    "base_expr" : substr(baseExpression, 0, -$token.length),
                                    "sub_tree" : [$option));
                    baseExpression = $token;
                    $currCategory = 'INDEX_SIZE';
                    continue 2;
                }
                break;

            case 'USING':
            // starts an index option
                if ($currCategory == 'INDEX_COL_LIST' || $currCategory == 'PRIMARY') {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = ["base_expr" : substr(baseExpression, 0, -$token.length), 'trim' : strippedToken,
                                    'category' : $currCategory, "sub_tree" : [$option));
                    baseExpression = $token;
                    $currCategory = 'INDEX_TYPE';
                    continue 2;
                }
                // else ?
                break;

            case 'REFERENCES':
                if ($currCategory == 'INDEX_COL_LIST' && $prevCategory == 'FOREIGN') {
                    $refs = this.processReferenceDefinition(array_slice($tokens, $k - 1, null, true));
                    $skip = $refs["till"] - $k;
                    unset($refs["till"]);
                    $expr[] = $refs;
                    $currCategory = upperToken;
                }
                // else ?
                break;

            case 'BTREE':
            case 'HASH':
                if ($currCategory == 'INDEX_TYPE') {
                    $last = array_pop($expr);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = ["expr_type" : expressionType(INDEX_TYPE, "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last["base_expr"] . baseExpression;

                    // FIXME: it could be wrong for index_type within index_option
                    $currCategory = $last["category"];
                    continue 2;
                }
                // else ?
                break;

            case '=':
                if ($currCategory == 'INDEX_SIZE') {
                    // the optional character between KEY_BLOCK_SIZE and the numeric constant
                    $last = array_pop($expr);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = $last;
                    continue 2;
                }
                break;

            case 'PARSER':
                if ($currCategory == 'INDEX_PARSER') {
                    $last = array_pop($expr);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr[] = $last;
                    continue 2;
                }
                // else ?
                break;

            case ',':
            // this starts the next definition
                $type = this.correctExpressionType($expr);
                $result["create-def"][] = ["expr_type" : $type,
                                                "base_expr" : trim(substr(baseExpression, 0, -$token.length)),
                                                "sub_tree" : $expr];
                baseExpression = "";
                $expr = [];
                break;

            default:
                switch ($currCategory) {

                case 'LIKE':
                // this is the tablename after LIKE
                    $expr[] = ["expr_type" : expressionType(TABLE, 'table' : strippedToken, "base_expr" : strippedToken,
                                    'no_quotes' : this.revokeQuotation(strippedToken));
                    break;

                case 'PRIMARY':
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        // the column list
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        $expr[] = ["expr_type" : expressionType(COLUMN_LIST, "base_expr" : strippedToken,
                                        "sub_tree" : $cols);
                        $prevCategory = $currCategory;
                        $currCategory = 'INDEX_COL_LIST';
                        continue 3;
                    }
                    // else?
                    break;

                case 'FOREIGN':
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        $expr[] = ["expr_type" : expressionType(COLUMN_LIST, "base_expr" : strippedToken,
                                        "sub_tree" : $cols);
                        $prevCategory = $currCategory;
                        $currCategory = 'INDEX_COL_LIST';
                        continue 3;
                    }
                    // index name
                    $expr[] = ["expr_type" : expressionType(CONSTANT, "base_expr": strippedToken];
                    continue 3;

                case 'KEY':
                case 'UNIQUE':
                case 'INDEX':
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        $expr[] = ["expr_type" : expressionType(COLUMN_LIST, "base_expr" : strippedToken,
                                        "sub_tree" : $cols);
                        $prevCategory = $currCategory;
                        $currCategory = 'INDEX_COL_LIST';
                        continue 3;
                    }
                    // index name
                    $expr[] = ["expr_type" : expressionType(CONSTANT, "base_expr": strippedToken];
                    continue 3;

                case 'CONSTRAINT':
                // constraint name
                    $last = array_pop($expr);
                    $last["base_expr"] = baseExpression;
                    $last["sub_tree"] = ["expr_type" : expressionType(CONSTANT, "base_expr": strippedToken];
                    $expr[] = $last;
                    continue 3;

                case 'INDEX_PARSER':
                // index parser name
                    $last = array_pop($expr);
                    $last["sub_tree"][] = ["expr_type" : expressionType(CONSTANT, "base_expr": strippedToken];
                    $expr[] = ["expr_type" : expressionType(INDEX_PARSER, "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last["base_expr"] . baseExpression;
                    $currCategory = 'INDEX_COL_LIST';
                    continue 3;

                case 'INDEX_SIZE':
                // index key block size numeric constant
                    $last = array_pop($expr);
                    $last["sub_tree"][] = ["expr_type" : expressionType(CONSTANT, "base_expr": strippedToken];
                    $expr[] = ["expr_type" : expressionType(INDEX_SIZE, "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last["base_expr"] . baseExpression;
                    $currCategory = 'INDEX_COL_LIST';
                    continue 3;

                case 'CHECK':
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $parsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                        $parsed = this.processExpressionList($parsed);
                        $expr[] = ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : strippedToken,
                                        "sub_tree" : $parsed);
                    }
                    // else?
                    break;

                case "":
                // if the currCategory is empty, we have an unknown token,
                // which is a column reference
                    $expr[] = ["expr_type" : expressionType(COLREF, "base_expr" : strippedToken,
                                    'no_quotes' : this.revokeQuotation(strippedToken));
                    $currCategory = 'COLUMN_NAME';
                    continue 3;

                case 'COLUMN_NAME':
                // the column-definition
                // it stops on a comma or on a parenthesis
                    $parsed = this.processColumnDefinition(array_slice($tokens, $k, null, true));
                    $skip = $parsed["till"] - $k;
                    unset($parsed["till"]);
                    $expr[] = $parsed;
                    $currCategory = "";
                    break;

                default:
                // ?
                    break;
                }
                break;
            }
            $prevCategory = $currCategory;
            $currCategory = "";
        }

        $type = this.correctExpressionType($expr);
        $result["create-def"][] = ["expr_type" : $type, "base_expr" : baseExpression.strip, "sub_tree" : $expr];
        return $result;
    }
}
