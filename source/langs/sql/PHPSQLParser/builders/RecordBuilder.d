
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
        $builder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::RECORD) {
            return isset($parsed["base_expr"]) ? $parsed["base_expr"] : "";
        }
        $sql = "";
        foreach ($parsed["data"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildColRef($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException(ExpressionType::RECORD, $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        }
        $sql = substr($sql, 0, -2);
        return "(" . $sql . ")";
    }

}
