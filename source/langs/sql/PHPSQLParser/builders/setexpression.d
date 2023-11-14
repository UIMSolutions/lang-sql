
/**
 * SetExpressionBuilder.php
 *
 * Builds the SET part of the INSERT statement. */

module source.langs.sql.PHPSQLParser.builders.setexpression;

import lang.sql;

@safe:

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
class SetExpressionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildSign($parsed) {
        auto myBuilder = new SignBuilder();
        return myBuilder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $delim = " ";
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildBracketExpression($v);
                        
            // we don't need whitespace between the sign and 
            // the following part
            if (this.buildSign($v) != '') {
                $delim = "";
            }
            mySql  ~= this.buildSign($v);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('SET expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= $delim;
        }
        mySql = substr(mySql, 0, -1);
        return mySql;
    }
}