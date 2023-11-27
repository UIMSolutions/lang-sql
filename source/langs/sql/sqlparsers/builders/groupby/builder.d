module langs.sql.sqlparsers.builders.groupby.builder;

import lang.sql;

@safe:

// Builder for the GROUP-BY clause. 
class GroupByBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = parsedSql.byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    mySql = substr(mySql, 0, -2);
    return "GROUP BY " ~ mySql;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildColRef(aValue);
    result ~= this.buildPosition(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildGroupByExpression(aValue);
    result ~= this.buildGroupByAlias(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("GROUP", aKey, aValue, "expr_type");
    }

    result ~= ", ";
    return result;
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildPosition(Json parsedSql) {
    auto myBuilder = new PositionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildFunction(Json parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildGroupByAlias(Json parsedSql) {
    auto myBuilder = new GroupByAliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildGroupByExpression(Json parsedSql) {
    auto myBuilder = new GroupByExpressionBuilder();
    return myBuilder.build(parsedSql);
  }
}
