module langs.sql.sqlparsers.builders.wherebracketexpression;

import langs.sql;

@safe:

// Builds bracket expressions within the WHERE part.
class WhereBracketExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
      return "";
    }
    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join(" ");

   mySql = "(" ~ substr(mySql, 0, -1) ~ ")";
    return mySql;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildColRef(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildOperator(aValue);
    result ~= this.buildInList(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildWhereExpression(aValue);
    result ~= this.build(aValue);
    result ~= this.buildUserVariable(aValue);
    // result ~= this.buildSubQuery(aValue);
    result ~= this.buildReserved(aValue);
    result ~= this.buildSubQuery(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("WHERE expression subtree", aKey, aValue, "expr_type");
    }

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

  protected string buildInList(Json parsedSql) {
    auto myBuilder = new InListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildWhereExpression(Json parsedSql) {
    auto myBuilder = new WhereExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildUserVariable(Json parsedSql) {
    auto myBuilder = new UserVariableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSubQuery(Json parsedSql) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }
}
