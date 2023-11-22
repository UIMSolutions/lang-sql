module langs.sql.sqlparsers.builders.subtree;

import lang.sql;

@safe:

/**
 * Builds the statements for [sub_tree] fields.
 * This class : the builder for [sub_tree] fields.
 * 
 */
class SubTreeBuilder : ISqlBuilder {

  string build(Json parsedSql, $delim = " ") {
    if (parsedSql["sub_tree"].isEmpty || parsedSql["sub_tree"] == false) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0,  - strlen($delim));
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
      throw new UnableToCreateSQLException("expression subtree", myKey, aValue.toString, "expr_type");
    }

    // We don"t need whitespace between a sign and the following part.
    if (mySign.isEmpty) {
      result ~= $delim;
    }
  }

  protected auto buildColRef(parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildFunction(parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildOperator(parsedSql) {
    auto myBuilder = new OperatorBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildConstant(parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildInList(parsedSql) {
    auto myBuilder = new InListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildReserved(parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildSubQuery(parsedSql) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildQuery(parsedSql) {
    auto myBuilder = new QueryBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildSelectBracketExpression(parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildUserVariable(parsedSql) {
    auto myBuilder = new UserVariableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildSign(parsedSql) {
    auto myBuilder = new SignBuilder();
    return myBuilder.build(parsedSql);
  }
}
