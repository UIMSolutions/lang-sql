module langs.sql.parsers.builders.havingexpression;

import langs.sql;

@safe:

// Builds expressions within the HAVING part.
class HavingExpressionBuilder : WhereExpressionBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("EXPRESSION")) {
      return null;
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

   mySql = substr(mySql, 0, -1);
    return mySql;
  }

  string buildKeyValue(string aKey, Json aValue) {
    string result;
    
    result ~= this.buildColRef(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildOperator(aValue);
    result ~= this.buildInList(aValue);
    result ~= this.buildFunction(aValue);
    result ~= this.buildHavingExpression(aValue);
    result ~= this.buildHavingBracketExpression(aValue);
    result ~= this.buildUserVariable(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("HAVING expression subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildHavingExpression(Json parsedSql) {
    return this.build(parsedSql);
  }

  protected string buildHavingBracketExpression(Json parsedSql) {
    auto myBuilder = new HavingBracketExpressionBuilder();
    return myBuilderr.build(parsedSql);
  }

}
