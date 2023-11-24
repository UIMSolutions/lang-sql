module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds auto statements. 
 * This class : the builder for auto calls. 
 *    */
class FunctionBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("AGGREGATE_FUNCTION")
            && parsedSql.isExpressionType("SIMPLE_FUNCTION")
            && parsedSql.isExpressionType("CUSTOM_FUNCTION")) {
            return "";
        }

        if (parsedSql["sub_tree"] == false) {
            return parsedSql["base_expr"] ~ "()" ~ this.buildAlias(parsedSql);
        }

        string result = parsedSql["sub_tree"].byKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        return parsedSql["base_expr"] ~ "(" ~ substr(result, 0, -1)
            ~ ")" ~ this.buildAlias(
                parsedSql);
    }

    string buildKeyValue(string aKey, Json aValue) {
        string result;
        result ~= this.build(aValue);
        result ~= this.buildConstant(aValue);
        result ~= this.buildSubQuery(aValue);
        result ~= this.buildColRef(aValue);
        result ~= this.buildReserved(aValue);
        result ~= this.buildSelectBracketExpression(aValue);
        result ~= this.buildSelectExpression(aValue);
        result ~= this.buildUserVariableExpression(aValue);
        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("auto subtree", myKey, aValue, "expr_type");
        }

        result ~= (this.isReserved(myValue) ? " " : ",");
        return result;
    }

    protected string buildAlias(Json parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto isReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilderr.isReserved(parsedSql);
    }

    protected string buildSelectExpression(Json parsedSql) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSelectBracketExpression(Json parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSubQuery(Json parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildUserVariableExpression(Json parsedSql) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSql);
    }

}
