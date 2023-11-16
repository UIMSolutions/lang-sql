


module langs.sql.PHPSQLParser.processors.indexcolumnist;

import lang.sql;

@safe:
// Processor for index column lists.
// This class processes the index column lists.
class IndexColumnListProcessor : AbstractProcessor {
    protected auto initExpression() {
        return ['name' : false, 'no_quotes' : false, 'length' : false, 'dir' : false);
    }

    auto process($sql) {
        $tokens = this.splitSQLIntoTokens($sql);

        $expr = this.initExpression();
        $result = [];
        baseExpression = "";

        foreach ($tokens as $k : $token) {

            auto strippedToken = $token.strip;
            baseExpression  ~= $token;

            if (strippedToken.isEmpty) {
                continue;
            }

            $upper = strippedToken.toUpper;

            switch ($upper) {

            case 'ASC':
            case 'DESC':
            # the optional order
                $expr["dir"] = strippedToken;
                break;

            case ',':
            # the next column
                $result[] = array_merge(["expr_type" : expressionType(INDEX_COLUMN, "base_expr" : baseExpression),
                        $expr);
                $expr = this.initExpression();
                baseExpression = "";
                break;

            default:
                if ($upper[0] == "(" && substr($upper, -1) == ")") {
                    # the optional length
                    $expr["length"] = this.removeParenthesisFromStart(strippedToken);
                    continue 2;
                }
                # the col name
                $expr["name"] = strippedToken;
                $expr["no_quotes"] = this.revokeQuotation(strippedToken);
                break;
            }
        }
        $result[] = array_merge(["expr_type" : expressionType(INDEX_COLUMN, "base_expr" : baseExpression), $expr);
        return $result;
    }
}