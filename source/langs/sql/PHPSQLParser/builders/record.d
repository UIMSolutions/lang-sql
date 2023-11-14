
/**
 * RecordBuilder.php
 *
 * Builds the records within the INSERT statement. */

module source.langs.sql.PHPSQLParser.builders.record;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the records within INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
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
        auto mySql = "";
        foreach (myKey, myValue; $parsed["data"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildColRef(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException(ExpressionType::RECORD, $k, myValue, 'expr_type');
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "(" . mySql . ")";
    }

}