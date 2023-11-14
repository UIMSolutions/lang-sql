
/**
 * InsertProcessor.php
 *
 * This file : the processor for the INSERT statements.
 */

module langs.sql.PHPSQLParser.processors.insert;

import lang.sql;

@safe:

/**
 * This class processes the INSERT statements.
 */
class InsertProcessor : AbstractProcessor {

    protected auto processOptions($tokenList) {
        if (!isset($tokenList["OPTIONS"])) {
            return array();
        }
        $result = array();
        foreach ($tokenList["OPTIONS"] as $token) {
            $result[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $token.strip);
        }
        return $result;
    }

    protected auto processKeyword($keyword, $tokenList) {
        if (!isset($tokenList[$keyword])) {
            return array('', false, array());
        }

        $table = "";
        $cols = false;
        $result = array();

        foreach ($tokenList[$keyword] as $token) {
            $trim = $token.strip;

            if ($trim == '') {
                continue;
            }

            $upper = $trim.toUpper;
            switch ($upper) {
            case 'INTO':
                $result[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'INSERT':
            case 'REPLACE':
                break;

            default:
                if ($table == '') {
                    $table = $trim;
                    break;
                }

                if ($cols == false) {
                    $cols = $trim;
                }
                break;
            }
        }
        return array($table, $cols, $result);
    }

    protected auto processColumns($cols) {
        if ($cols == false) {
            return $cols;
        }
        if ($cols[0] == "(" && substr($cols, -1) == ")") {
            $parsed = array('expr_type' => ExpressionType::BRACKET_EXPRESSION, 'base_expr' => $cols,
                            'sub_tree' => false);
        }
        $cols = this.removeParenthesisFromStart($cols);
        if (stripos($cols, 'SELECT') == 0) {
            auto myProcessor = new DefaultProcessor(this.options);
            $parsed["sub_tree"] = array(
                    array('expr_type' => ExpressionType::QUERY, 'base_expr' => $cols,
                            'sub_tree' => $processor.process($cols)));
        } else {
            auto myProcessor = new ColumnListProcessor(this.options);
            $parsed["sub_tree"] = $processor.process($cols);
            $parsed["expr_type"] = ExpressionType::COLUMN_LIST;
        }
        return $parsed;
    }

    auto process($tokenList, $token_category = 'INSERT') {
        $table = "";
        $cols = false;
        $comments = array();

        foreach ($tokenList as $key => &$token) {
            if ($key == 'VALUES') {
                continue;
            }
            foreach ($token as &$value) {
                if (this.isCommentToken($value)) {
                     $comments[] = super.processComment($value);
                     $value = "";
                }
            }
        }

        $parsed = this.processOptions($tokenList);
        unset($tokenList["OPTIONS"]);

        list($table, $cols, $key) = this.processKeyword('INTO', $tokenList);
        $parsed = array_merge($parsed, $key);
        unset($tokenList["INTO"]);

        if ($table == '' && in_array($token_category, array('INSERT', 'REPLACE'))) {
            list($table, $cols, $key) = this.processKeyword($token_category, $tokenList);
        }

        $parsed[] = array('expr_type' => ExpressionType::TABLE, 'table' => $table,
                          'no_quotes' => this.revokeQuotation($table), 'alias' => false, 'base_expr' => $table);

        $cols = this.processColumns($cols);
        if ($cols != false) {
            $parsed[] = $cols;
        }

        $parsed = array_merge($parsed, $comments);

        $tokenList[$token_category] = $parsed;
        return $tokenList;
    }
}
