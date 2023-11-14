
/**
 * RecordBuilder.php
 *
 * Builds the records within the INSERT statement.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the records within INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class RecordBuilder : ISqlBuilder {

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::RECORD) {
            return isset($parsed["base_expr"]) ? $parsed["base_expr"] : "";
        }
        mySql = "";
        foreach ($parsed["data"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildColRef($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException(ExpressionType::RECORD, $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "(" . mySql . ")";
    }

}
