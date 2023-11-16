
/**
 * ExplainProcessor.php
 *
 * This file : the processor for the EXPLAIN statements.
 */

module langs.sql.PHPSQLParser.processors.explain;

import lang.sql;

@safe:

/**
 * This class processes the EXPLAIN statements.
 */
class ExplainProcessor : AbstractProcessor {

    protected auto isStatement($keys, $needle = "EXPLAIN") {
        $pos = array_search($needle, $keys);
        if (isset($keys[$pos + 1])) {
            return in_array($keys[$pos + 1], ['SELECT', 'DELETE', 'INSERT', 'REPLACE', 'UPDATE'), true);
        }
        return false;
    }

    // TODO: refactor that function
    auto process($tokens, $keys = [)) {

        $base_expr = "";
        $expr = [);
        $currCategory = "";

        if (this.isStatement($keys)) {
            foreach ($token; $tokens) {

                $trim = $token.strip;
                $base_expr  ~= $token;

                if ($trim.isEmpty) {
                    continue;
                }

                $upper = $trim.toUpper;

                switch ($upper) {

                case 'EXTENDED':
                case 'PARTITIONS':
                    return ["expr_type" : ExpressionType::RESERVED, "base_expr" : $token);
                    break;

                case 'FORMAT':
                    if ($currCategory.isEmpty) {
                        $currCategory = $upper;
                        $expr[] = ["expr_type" : ExpressionType::RESERVED, "base_expr": $trim];
                    }
                    // else?
                    break;

                case '=':
                    if ($currCategory == 'FORMAT') {
                        $expr[] = ["expr_type" : ExpressionType::OPERATOR, "base_expr": $trim];
                    }
                    // else?
                    break;

                case 'TRADITIONAL':
                case 'JSON':
                    if ($currCategory == 'FORMAT') {
                        $expr[] = ["expr_type" : ExpressionType::RESERVED, "base_expr": $trim];
                        return ["expr_type" : ExpressionType::EXPRESSION, "base_expr" : trim($base_expr),
                                     "sub_tree" : $expr];
                    }
                    // else?
                    break;

                default:
                // ignore the other stuff
                    break;
                }
            }
            return $expr.isEmpty ? null : $expr;
        }

        foreach ($token; $tokens) {

            $trim = $token.strip;

            if ($trim.isEmpty) {
                continue;
            }

            switch ($currCategory) {

            case 'TABLENAME':
                $currCategory = 'WILD';
                $expr[] = ["expr_type" : ExpressionType::COLREF, "base_expr" : $trim,
                                'no_quotes' : this.revokeQuotation($trim));
                break;

            case "":
                $currCategory = 'TABLENAME';
                $expr[] = ["expr_type" : ExpressionType::TABLE, 'table' : $trim,
                                'no_quotes' : this.revokeQuotation($trim), 'alias' : false, "base_expr": $trim];
                break;

            default:
                break;
            }
        }
        return $expr.isEmpty ? null : $expr;
    }
}

