module langs.sql.sqlparsers.builders.subtree;

import langs.sql;

@safe:

// Builds the statements for [sub_tree] fields.
class SubTreeBuilder : ISqlBuilder {

  string build(Json parsedSql, string delim = " ") {
    if (parsedSql["sub_tree"].isEmpty) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0,  -delim.length);
  }

  string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildColRef(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildOperator(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildInList(aValue);
    result ~= this.buildSubQuery(aValue);
    result ~= this.buildSelectBracketExpression(aValue);
    result ~= this.buildReserved(aValue);
    result ~= this.buildQuery(aValue);
    result ~= this.buildUserVariable(aValue);

    string mySign = this.buildSign(aValue);
    result ~= mySign;

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("expression subtree", aKey, aValue.toString, "expr_type");
    }

    // We don"t need whitespace between a sign and the following part.
    if (mySign.isEmpty) {
      result ~= delim;
    }

    return result;
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildFunction(Json parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildOperator(Json parsedSql) {
    auto myBuilder = new OperatorBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildInList(Json parsedSql) {
    auto myBuilder = new InListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSubQuery(Json parsedSql) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildQuery(Json parsedSql) {
    auto myBuilder = new QueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSelectBracketExpression(Json parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildUserVariable(Json parsedSql) {
    auto myBuilder = new UserVariableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSign(Json parsedSql) {
    auto myBuilder = new SignBuilder();
    return myBuilder.build(parsedSql);
  }
}
