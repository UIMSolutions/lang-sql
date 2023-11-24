module langs.sql.sqlparsers.builders.havingbracketexpression;

import lang.sql;

@safe:

// Builds bracket expressions within the HAVING part.
class HavingBracketExpressionBuilder : WhereBracketExpressionBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

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
    result ~= this.buildHavingExpression(aValue);
    result ~= this.build(aValue);
    result ~= this.buildUserVariable(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("HAVING expression subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildHavingExpression(Json parsedSql) {
    auto myBuilder = new HavingExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

}
