module langs.sql.sqlparsers.builders.orderby.builder;

import langs.sql;

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

  protected string buildFunction(Json parsedSql) {
    auto myBuilder = new OrderByFunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new OrderByReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new OrderByColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildAlias(Json parsedSql) {
    auto myBuilder = new OrderByAliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildExpression(Json parsedSql) {
    auto myBuilder = new OrderByExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildBracketExpression(Json parsedSql) {
    auto myBuilder = new OrderByBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildPosition(Json parsedSql) {
    auto myBuilder = new OrderByPositionBuilder();
    return myBuilder.build(parsedSql);
  }
}
