
/**
 * ReferenceDefinitionProcessor.php
 *
 * This file : the processor reference definition part of the CREATE TABLE statements.
 */

module langs.sql.PHPSQLParser.processors.referencedefinition;

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

        $expr = ["expr_type" : expressionType(REFERENCE, "base_expr" : false, "sub_tree" : []);
        $base_expr = "";

        foreach ($key : $token; $tokens) {

            auto strippedToken = $token.strip;
            $base_expr  ~= $token;

            if (strippedToken.isEmpty) {
                continue;
            }

            $upper = strippedToken.toUpper;

            switch ($upper) {

            case ',':
            # we stop on a single comma
            # or at the end of the array $tokens
                $expr = this.buildReferenceDef($expr, trim(substr($base_expr, 0, -$token.length)), $key - 1);
                break 2;

            case 'REFERENCES':
                $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                $currCategory = $upper;
                break;

            case 'MATCH':
                if ($currCategory == 'REF_COL_LIST') {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $currCategory = 'REF_MATCH';
                    continue 2;
                }
                # else?
                break;

            case 'FULL':
            case 'PARTIAL':
            case 'SIMPLE':
                if ($currCategory == 'REF_MATCH') {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr["match"] = $upper;
                    $currCategory = 'REF_COL_LIST';
                    continue 2;
                }
                # else?
                break;

            case 'ON':
                if ($currCategory == 'REF_COL_LIST') {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $currCategory = 'REF_ACTION';
                    continue 2;
                }
                # else ?
                break;

            case 'UPDATE':
            case 'DELETE':
                if ($currCategory == 'REF_ACTION') {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $currCategory = 'REF_OPTION_' . $upper;
                    continue 2;
                }
                # else ?
                break;

            case 'RESTRICT':
            case 'CASCADE':
                if (strpos($currCategory, 'REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr["on_"  ~ strtolower(substr($currCategory, -6))] = $upper;
                    continue 2;
                }
                # else ?
                break;

            case 'SET':
            case 'NO':
                if (strpos($currCategory, 'REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr["on_" ~ strtolower(substr($currCategory, -6))] = $upper;
                    $currCategory = 'SEC_' . $currCategory;
                    continue 2;
                }
                # else ?
                break;

            case 'NULL':
            case 'ACTION':
                if (strpos($currCategory, 'SEC_REF_OPTION_') == 0) {
                    $expr["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    $expr["on_" ~ strtolower(substr($currCategory, -6))]  ~= " " ~ $upper;
                    $currCategory = 'REF_COL_LIST';
                    continue 2;
                }
                # else ?
                break;

            default:
                switch ($currCategory) {

                case 'REFERENCES':
                    if ($upper[0] == "(" && substr($upper, -1) == ")") {
                        # index_col_name list
                        auto myProcessor = new IndexColumnListProcessor(this.options);
                        $cols = $processor.process(this.removeParenthesisFromStart(strippedToken));
                        $expr["sub_tree"][] = ["expr_type" : expressionType(COLUMN_LIST, "base_expr" : strippedToken,
                                                    "sub_tree" : $cols);
                        $currCategory = 'REF_COL_LIST';
                        continue 3;
                    }
                    # foreign key reference table name
                    $expr["sub_tree"][] = ["expr_type" : expressionType(TABLE, 'table' : strippedToken,
                                                "base_expr" : strippedToken, 'no_quotes' : this.revokeQuotation(strippedToken));
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