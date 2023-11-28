module langs.sql.sqlparsers.builders.where;

import lang.sql;

@safe:

// Builds the WHERE part.
class WhereBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    auto mySql = "WHERE ";
    parsedSql.byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildOperator(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildColRef(aValue);
    result ~= this.buildSubQuery(aValue);
    result ~= this.buildInList(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildWhereExpression(aValue);
    result ~= this.buildWhereBracketExpression(aValue);
    result ~= this.buildUserVariable(aValue);
    result ~= this.buildReserved(aValue);

    if (result.isEmpty) {
      throw new UnableToCreateSQLException("WHERE", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
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

  protected string buildSubQuery(Json parsedSql) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildInList(Json parsedSql) {
    auto myBuilder = new InListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildWhereExpression(Json parsedSql) {
    auto myBuilder = new WhereExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildWhereBracketExpression(Json parsedSql) {
    auto myBuilder = new WhereBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildUserVariable(Json parsedSql) {
    auto myBuilder = new UserVariableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }
}
