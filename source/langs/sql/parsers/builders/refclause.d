module langs.sql.sqlparsers.builders.refclause;

import langs.sql;

@safe:

/**
 * Builds reference clauses within a JOIN.
 * This class : the references clause within a JOIN.
 */
class RefClauseBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (parsedSql.isEmpty) {
            return "";
        }

        string mySql = parsedSql.byKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        return substr(mySql, 0, -1);
    }

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;
        result ~= this.buildColRef(aValue);
        result ~= this.buildOperator(aValue);
        result ~= this.buildConstant(aValue);
        result ~= this.buildFunction(aValue);
        result ~= this.buildBracketExpression(aValue);
        result ~= this.buildInList(aValue);
        result ~= this.buildColumnList(aValue);
        result ~= this.buildSubQuery(aValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("expression ref_clause", aKey, aValue, "expr_type");
        }

        result ~= " ";
        return result;
    }

    protected string buildInList(Json parsedSql) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildOperator(Json parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFunction(Json parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildBracketExpression(Json parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSubQuery(Json parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }
}
