
module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds auto statements. 
 * This class : the builder for auto calls. 
 * You can overwrite all functions to achieve another handling.   */
class FunctionBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColRef(parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto isReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilderr.isReserved(parsedSql);
    }
    
    protected auto buildSelectExpression(parsedSql) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSelectBracketExpression(parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildSubQuery(parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildUserVariableExpression(parsedSql) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if ((parsedSql["expr_type"] !.isExpressionType(AGGREGATE_FUNCTION)
            && (parsedSql["expr_type"] !.isExpressionType(SIMPLE_FUNCTION)
            && (parsedSql["expr_type"] !.isExpressionType(CUSTOM_FUNCTION)) {
            return "";
        }

        if (parsedSql["sub_tree"] == false) {
            return parsedSql["base_expr"] . "()" . this.buildAlias(parsedSql);
        }

        string mySql = "";
        foreach (myKey, myValue, parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.build(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildSelectBracketExpression(myValue);
            mySql ~= this.buildSelectExpression(myValue);
            mySql ~= this.buildUserVariableExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("auto subtree", myKey, myValue, "expr_type");
            }

            mySql ~= (this.isReserved(myValue) ? " " : ",");
        }
        return parsedSql["base_expr"] . "(" . substr(mySql, 0, -1) . ")" . this.buildAlias(parsedSql);
    }

}
