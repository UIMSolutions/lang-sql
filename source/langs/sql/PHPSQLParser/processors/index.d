
/**
 * IndexProcessor.php
 *
 * This file : the processor for the INDEX statements.
 */

module langs.sql.PHPSQLParser.processors.index;

import lang.sql;

@safe:

// This class processes the INDEX statements.
class IndexProcessor : AbstractProcessor {

    protected auto getReservedType($token) {
        return array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $token);
    }

    protected auto getConstantType($token) {
        return array('expr_type' => ExpressionType::CONSTANT, 'base_expr' => $token);
    }

    protected auto getOperatorType($token) {
        return array('expr_type' => ExpressionType::OPERATOR, 'base_expr' => $token);
    }

    protected auto processIndexColumnList($parsed) {
        auto myProcessor = new IndexColumnListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    auto process($tokens) {

        $currCategory = 'INDEX_NAME';
        $result = array('base_expr' => false, 'name' => false, 'no_quotes' => false, 'index-type' => false, 'on' => false,
                        'options' => array());
        $expr = array();
        $base_expr = "";
        $skip = 0;

        foreach ($tokens as $tokenKey => $token) {
            $trim = trim($token);
            $base_expr  ~= $token;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if ($trim == '') {
                continue;
            }

            $upper = strtoupper($trim);
            switch ($upper) {

            case 'USING':
                if ($prevCategory == 'CREATE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'TYPE_OPTION';
                    continue 2;
                }
                if ($prevCategory == 'TYPE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'INDEX_TYPE';
                    continue 2;
                }
                // else ?
                break;

            case 'KEY_BLOCK_SIZE':
                if ($prevCategory == 'CREATE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'INDEX_OPTION';
                    continue 2;
                }
                // else ?
                break;

            case 'WITH':
                if ($prevCategory == 'CREATE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'INDEX_PARSER';
                    continue 2;
                }
                // else ?
                break;

            case 'PARSER':
                if ($currCategory == 'INDEX_PARSER') {
                    $expr[] = this.getReservedType($trim);
                    continue 2;
                }
                // else ?
                break;

            case 'COMMENT':
                if ($prevCategory == 'CREATE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'INDEX_COMMENT';
                    continue 2;
                }
                // else ?
                break;

            case 'ALGORITHM':
            case 'LOCK':
                if ($prevCategory == 'CREATE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = $upper . '_OPTION';
                    continue 2;
                }
                // else ?
                break;

            case '=':
            // the optional operator
                if (substr($currCategory, -7, 7) == '_OPTION') {
                    $expr[] = this.getOperatorType($trim);
                    continue 2; // don't change the category
                }
                // else ?
                break;

            case 'ON':
                if ($prevCategory == 'CREATE_DEF' || $prevCategory == 'TYPE_DEF') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = 'TABLE_DEF';
                    continue 2;
                }
                // else ?
                break;

            default:
                switch ($currCategory) {

                case 'COLUMN_DEF':
                    if ($upper[0] == '(' && substr($upper, -1) == ')') {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart($trim));
                        $result["on"]["base_expr"]  ~= $base_expr;
                        $result["on"]["sub_tree"] = array('expr_type' => ExpressionType::COLUMN_LIST,
                                                          'base_expr' => $trim, 'sub_tree' => $cols);
                    }

                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';
                    break;

                case 'TABLE_DEF':
                // the table name
                    $expr[] = this.getConstantType($trim);
                    // TODO: the base_expr should contain the column-def too
                    $result["on"] = array('expr_type' => ExpressionType::TABLE, 'base_expr' => $base_expr,
                                          'name' => $trim, 'no_quotes' => this.revokeQuotation($trim),
                                          'sub_tree' => false);
                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'COLUMN_DEF';
                    continue 3;

                case 'INDEX_NAME':
                    $result["base_expr"] = $result["name"] = $trim;
                    $result["no_quotes"] = this.revokeQuotation($trim);

                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'TYPE_DEF';
                    break;

                case 'INDEX_PARSER':
                // the parser name
                    $expr[] = this.getConstantType($trim);
                    $result["options"][] = array('expr_type' => ExpressionType::INDEX_PARSER,
                                                 'base_expr' => trim($base_expr), 'sub_tree' => $expr);
                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';

                    break;

                case 'INDEX_COMMENT':
                // the index comment
                    $expr[] = this.getConstantType($trim);
                    $result["options"][] = array('expr_type' => ExpressionType::COMMENT,
                                                 'base_expr' => trim($base_expr), 'sub_tree' => $expr);
                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';

                    break;

                case 'INDEX_OPTION':
                // the key_block_size
                    $expr[] = this.getConstantType($trim);
                    $result["options"][] = array('expr_type' => ExpressionType::INDEX_SIZE,
                                                 'base_expr' => trim($base_expr), 'size' => $upper,
                                                 'sub_tree' => $expr);
                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';

                    break;

                case 'INDEX_TYPE':
                case 'TYPE_OPTION':
                // BTREE or HASH
                    $expr[] = this.getReservedType($trim);
                    if ($currCategory == 'INDEX_TYPE') {
                        $result["index-type"] = array('expr_type' => ExpressionType::INDEX_TYPE,
                                                      'base_expr' => trim($base_expr), 'using' => $upper,
                                                      'sub_tree' => $expr);
                    } else {
                        $result["options"][] = array('expr_type' => ExpressionType::INDEX_TYPE,
                                                     'base_expr' => trim($base_expr), 'using' => $upper,
                                                     'sub_tree' => $expr);
                    }

                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';
                    break;

                case 'LOCK_OPTION':
                // DEFAULT|NONE|SHARED|EXCLUSIVE
                    $expr[] = this.getReservedType($trim);
                    $result["options"][] = array('expr_type' => ExpressionType::INDEX_LOCK,
                                                 'base_expr' => trim($base_expr), 'lock' => $upper,
                                                 'sub_tree' => $expr);

                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';
                    break;

                case 'ALGORITHM_OPTION':
                // DEFAULT|INPLACE|COPY
                    $expr[] = this.getReservedType($trim);
                    $result["options"][] = array('expr_type' => ExpressionType::INDEX_ALGORITHM,
                                                 'base_expr' => trim($base_expr), 'algorithm' => $upper,
                                                 'sub_tree' => $expr);

                    $expr = array();
                    $base_expr = "";
                    $currCategory = 'CREATE_DEF';

                    break;

                default:
                    break;
                }

                break;
            }

            $prevCategory = $currCategory;
            $currCategory = "";
        }

        if ($result["options"] == array()) {
            $result["options"] = false;
        }
        return $result;
    }
}
