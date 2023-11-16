module langs.sql.PHPSQLParser.processors.explain;

import lang.sql;

@safe:

/**
 * This file : the processor for the EXPLAIN statements.
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
    auto process($tokens, $keys = []) {

        $base_expr = "";
        $expr = [];
        $currCategory = "";

        if (this.isStatement($keys)) {
            foreach (myToken; $tokens) {

                $trim = myToken.strip;
                $base_expr  ~= myToken;

                if ($trim.isEmpty) {
                    continue;
                }

                $upper = $trim.toUpper;

                switch ($upper) {

                case 'EXTENDED':
                case 'PARTITIONS':
                    return ["expr_type" : expressionType("RESERVED"), "base_expr" : myToken);
                    break;

                case 'FORMAT':
                    if ($currCategory.isEmpty) {
                        $currCategory = $upper;
                        $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                    }
                    // else?
                    break;

                case '=':
                    if ($currCategory == 'FORMAT') {
                        $expr[] = ["expr_type" : expressionType(OPERATOR, "base_expr": $trim];
                    }
                    // else?
                    break;

                case 'TRADITIONAL':
                case 'JSON':
                    if ($currCategory == 'FORMAT') {
                        $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                        return ["expr_type" : expressionType("EXPRESSION"), "base_expr" : trim($base_expr),
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

        foreach (myToken; $tokens) {

            $trim = myToken.strip;

            if ($trim.isEmpty) {
                continue;
            }

            switch ($currCategory) {

            case 'TABLENAME':
                $currCategory = 'WILD';
                $expr[] = ["expr_type" : expressionType(COLREF, "base_expr" : $trim,
                                'no_quotes' : this.revokeQuotation($trim));
                break;

            case "":
                $currCategory = 'TABLENAME';
                $expr[] = ["expr_type" : expressionType(TABLE, 'table' : $trim,
                                'no_quotes' : this.revokeQuotation($trim), 'alias' : false, "base_expr": $trim];
                break;

            default:
                break;
            }
        }
        return $expr.isEmpty ? null : $expr;
    }
}

