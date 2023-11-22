module langs.sql.sqlparsers.builders.subtree;

import lang.sql;

@safe:

/**
 * Builds the statements for [sub_tree] fields.
 * This class : the builder for [sub_tree] fields.
 * You can overwrite all functions to achieve another handling.
 */
class SubTreeBuilder : ISqlBuilder {

  string build(Json parsedSQL, $delim = " ") {
    if (parsedSQL["sub_tree"].isEmpty || parsedSQL["sub_tree"] == false) {
      return "";
    }

    string mySql = parsedSQL["sub_tree"].byKeyValue
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

  protected auto buildColRef(parsedSQL) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildFunction(parsedSQL) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildOperator(parsedSQL) {
    auto myBuilder = new OperatorBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildConstant(parsedSQL) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildInList(parsedSQL) {
    auto myBuilder = new InListBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildReserved(parsedSQL) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildSubQuery(parsedSQL) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildQuery(parsedSQL) {
    auto myBuilder = new QueryBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildSelectBracketExpression(parsedSQL) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildUserVariable(parsedSQL) {
    auto myBuilder = new UserVariableBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildSign(parsedSQL) {
    auto myBuilder = new SignBuilder();
    return myBuilder.build(parsedSQL);
  }
}
