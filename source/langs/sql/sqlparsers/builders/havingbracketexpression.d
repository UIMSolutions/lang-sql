module langs.sql.sqlparsers.builders.havingbracketexpression;

import lang.sql;

@safe:

/**
 * Builds bracket expressions within the HAVING part.
 * This class : the builder for bracket expressions within the HAVING part. 
 * 
 */
class HavingBracketExpressionBuilder : WhereBracketExpressionBuilder {

  protected auto buildHavingExpression(Json parsedSql) {
    auto myBuilder = new HavingExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
      return "";
    }

    string mySql = "";
    foreach (myKey, myValue; parsedSql["sub_tree"]) {
      size_t oldSqlLength = mySql.length;
      mySql ~= this.buildColRef(myValue);
      mySql ~= this.buildConstant(myValue);
      mySql ~= this.buildOperator(myValue);
      mySql ~= this.buildInList(myValue);
      mySql ~= this.buildFunction(myValue);
      mySql ~= this.buildHavingExpression(myValue);
      mySql ~= this.build(myValue);
      mySql ~= this.buildUserVariable(myValue);

      if (oldSqlLength == mySql.length) { // No change
        throw new UnableToCreateSQLException("HAVING expression subtree", myKey, myValue, "expr_type");
      }

      mySql ~= " ";
    }

    mySql = "(" ~ substr(mySql, 0, -1) ~ ")";
    return mySql;
  }

}
