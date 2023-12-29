module langs.sql.parsers.builders.selects.selectexpression;

import langs.sql;

@safe:

// Builds simple expressions within a SELECT statement.
class SelectExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("EXPRESSION")) {
      return "";
    }

    string mySql = this.buildSubTree(parsedSql, " ");
   mySql ~= this.buildAlias(parsedSql);
    return mySql;
  }

  protected string buildSubTree(parsedSql, string delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, delim);
  }

  protected string buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }
}
