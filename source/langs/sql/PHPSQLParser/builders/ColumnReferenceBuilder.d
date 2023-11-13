module lang.sql.parsers.builders;

use SqlParser\utils\ExpressionType;

class ColumnReferenceBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        $builder = new AliasBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLREF) {
            return "";
        }
        
        auto mySql = $parsed["base_expr"];
        mySql  ~= this.buildAlias($parsed);
        return mySql;
    }
}
