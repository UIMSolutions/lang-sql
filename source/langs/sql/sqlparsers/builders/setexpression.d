module langs.sql.sqlparsers.builders.setexpression;

import lang.sql;

@safe:

// Builds the SET part of the INSERT statement. */
class SetExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("EXPRESSION")) {
      return "";
    }
    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    mySql = substr(mySql, 0, -1);
    return mySql;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string myDelim = " ";
    string result;
    result ~= this.buildColRef(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildOperator(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildBracketExpression(aValue);

    // we don"t need whitespace between the sign and 
    // the following part
    if (this.buildSign(aValue) != "") {
      myDelim = "";
    }

    myresultSql ~= this.buildSign(aValue);

    if (oldSqlLength == mySql.length) { // No change
      throw new UnableToCreateSQLException("SET expression subtree", aKey, aValue, "expr_type");
    }

    result ~= myDelim;
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

  protected string buildBracketExpression(Json parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected austringto buildSign(Json parsedSql) {
    auto myBuilder = new SignBuilder();
    return myBuilder.build(parsedSql);
  }
}
