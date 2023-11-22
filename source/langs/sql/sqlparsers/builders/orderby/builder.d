module langs.sql.sqlparsers.builders.orderby.builder;

import lang.sql;

@safe:

// Builds the ORDERBY clause. 
class OrderByBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string result = parsedSql.myKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        return "ORDER BY " ~ substr(result, 0, -2);
    }

    string buildKeyValue(string aKey, Json aValue) {
        string result;
        result ~= this.buildAlias(aValue);
        result ~= this.buildColRef(aValue);
        result ~= this.buildFunction(aValue);
        result ~= this.buildExpression(aValue);
        result ~= this.buildBracketExpression(aValue);
        result ~= this.buildReserved(aValue);
        result ~= this.buildPosition(aValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("ORDER", aKey, aValue, "expr_type");
        }

        result ~= ", ";
        return result;
    }

    protected auto buildFunction(Json parsedSql) {
        auto myBuilder = new OrderByFunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new OrderByReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColRef(Json parsedSql) {
        auto myBuilder = new OrderByColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildAlias(Json parsedSql) {
        auto myBuilder = new OrderByAliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildExpression(Json parsedSql) {
        auto myBuilder = new OrderByExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildBracketExpression(Json parsedSql) {
        auto myBuilder = new OrderByBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildPosition(Json parsedSql) {
        auto myBuilder = new OrderByPositionBuilder();
        return myBuilder.build(parsedSql);
    }
}
