
module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds auto statements. 
 * This class : the builder for auto calls. 
 * You can overwrite all functions to achieve another handling.   */
class FunctionBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto isReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilderr.isReserved(parsedSQL);
    }
    
    protected auto buildSelectExpression(parsedSQL) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSelectBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildSubQuery(parsedSQL) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildUserVariableExpression(parsedSQL) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if ((parsedSQL["expr_type"] !.isExpressionType(AGGREGATE_FUNCTION)
            && (parsedSQL["expr_type"] !.isExpressionType(SIMPLE_FUNCTION)
            && (parsedSQL["expr_type"] !.isExpressionType(CUSTOM_FUNCTION)) {
            return "";
        }

        if (parsedSQL["sub_tree"] == false) {
            return parsedSQL["base_expr"] . "()" . this.buildAlias(parsedSQL);
        }

        string mySql = "";
        foreach (myKey, myValue, parsedSQL["sub_tree"]) {
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
        return parsedSQL["base_expr"] . "(" . substr(mySql, 0, -1) . ")" . this.buildAlias(parsedSQL);
    }

}
