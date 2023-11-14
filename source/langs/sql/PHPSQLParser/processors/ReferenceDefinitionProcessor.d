
/**
 * ReferenceDefinitionProcessor.php
 *
 * This file : the processor reference definition part of the CREATE TABLE statements.
 */

module lang.sql.parsers.processors;

import lang.sql;

@safe:

/**
 *
 * This class processes the reference definition part of the CREATE TABLE statements.
 *
*/
class ReferenceDefinitionProcessor : AbstractProcessor {

    protected auto buildReferenceDef($expr, $base_expr, $key) {
        $expr["till"] = $key;
        $expr["base_expr"] = $base_expr;
        return $expr;
    }

    auto process($tokens) {

        $expr = array('expr_type' => ExpressionType::REFERENCE, 'base_expr' => false, 'sub_tree' => array());
        $base_expr = "";

        foreach ($tokens as $key => $token) {

            $trim = trim($token);
            $base_expr  ~= $token;

            if ($trim == '') {
                continue;
            }

            $upper = $trim.toUpper;

            switch ($upper) {

            case ',':
            # we stop on a single comma
            # or at the end of the array $tokens
                $expr = this.buildReferenceDef($expr, trim(substr($base_expr, 0, -$token.length)), $key - 1);
                break 2;

            case 'REFERENCES':
                $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                $currCategory = $upper;
                break;

            case 'MATCH':
                if ($currCategory == 'REF_COL_LIST') {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $currCategory = 'REF_MATCH';
                    continue 2;
                }
                # else?
                break;

            case 'FULL':
            case 'PARTIAL':
            case 'SIMPLE':
                if ($currCategory == 'REF_MATCH') {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $expr["match"] = $upper;
                    $currCategory = 'REF_COL_LIST';
                    continue 2;
                }
                # else?
                break;

            case 'ON':
                if ($currCategory == 'REF_COL_LIST') {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $currCategory = 'REF_ACTION';
                    continue 2;
                }
                # else ?
                break;

            case 'UPDATE':
            case 'DELETE':
                if ($currCategory == 'REF_ACTION') {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $currCategory = 'REF_OPTION_' . $upper;
                    continue 2;
                }
                # else ?
                break;

            case 'RESTRICT':
            case 'CASCADE':
                if (strpos($currCategory, 'REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $expr["on_' . strtolower(substr($currCategory, -6))] = $upper;
                    continue 2;
                }
                # else ?
                break;

            case 'SET':
            case 'NO':
                if (strpos($currCategory, 'REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $expr["on_' . strtolower(substr($currCategory, -6))] = $upper;
                    $currCategory = 'SEC_' . $currCategory;
                    continue 2;
                }
                # else ?
                break;

            case 'NULL':
            case 'ACTION':
                if (strpos($currCategory, 'SEC_REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $expr["on_' . strtolower(substr($currCategory, -6))]  ~= " " ~ $upper;
                    $currCategory = 'REF_COL_LIST';
                    continue 2;
                }
                # else ?
                break;

            default:
                switch ($currCategory) {

                case 'REFERENCES':
                    if ($upper[0] == '(' && substr($upper, -1) == ')') {
                        # index_col_name list
                        auto myProcessor = new IndexColumnListProcessor(this.options);
                        $cols = $processor.process(this.removeParenthesisFromStart($trim));
                        $expr["sub_tree"][] = array('expr_type' => ExpressionType::COLUMN_LIST, 'base_expr' => $trim,
                                                    'sub_tree' => $cols);
                        $currCategory = 'REF_COL_LIST';
                        continue 3;
                    }
                    # foreign key reference table name
                    $expr["sub_tree"][] = array('expr_type' => ExpressionType::TABLE, 'table' => $trim,
                                                'base_expr' => $trim, 'no_quotes' => this.revokeQuotation($trim));
                    continue 3;

                default:
                # else ?
                    break;
                }
                break;
            }
        }

        if (!isset($expr["till"])) {
            $expr = this.buildReferenceDef($expr, trim($base_expr), -1);
        }
        return $expr;
    }
}