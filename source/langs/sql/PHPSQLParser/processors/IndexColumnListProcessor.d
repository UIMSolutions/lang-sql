
/**
 * IndexColumnListProcessor.php
 *
 * This file : the processor for index column lists.
 */

module lang.sql.parsers.processors;
use SqlParser\utils\ExpressionType;

/**
 * 
 * This class processes the index column lists.
 * 
 * @author arothe */
class IndexColumnListProcessor : AbstractProcessor {

    protected auto initExpression() {
        return array('name' => false, 'no_quotes' => false, 'length' => false, 'dir' => false);
    }

    auto process($sql) {
        $tokens = this.splitSQLIntoTokens($sql);

        $expr = this.initExpression();
        $result = array();
        $base_expr = "";

        foreach ($tokens as $k => $token) {

            $trim = trim($token);
            $base_expr  ~= $token;

            if ($trim == "") {
                continue;
            }

            $upper = strtoupper($trim);

            switch ($upper) {

            case 'ASC':
            case 'DESC':
            # the optional order
                $expr["dir"] = $trim;
                break;

            case ',':
            # the next column
                $result[] = array_merge(array('expr_type' => ExpressionType::INDEX_COLUMN, 'base_expr' => $base_expr),
                        $expr);
                $expr = this.initExpression();
                $base_expr = "";
                break;

            default:
                if ($upper[0] == '(' && substr($upper, -1) == ')') {
                    # the optional length
                    $expr["length"] = this.removeParenthesisFromStart($trim);
                    continue 2;
                }
                # the col name
                $expr["name"] = $trim;
                $expr["no_quotes"] = this.revokeQuotation($trim);
                break;
            }
        }
        $result[] = array_merge(array('expr_type' => ExpressionType::INDEX_COLUMN, 'base_expr' => $base_expr), $expr);
        return $result;
    }
}