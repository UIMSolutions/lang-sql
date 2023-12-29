module langs.sql.parsers.builders.inlist;

import langs.sql;

@safe:

// Builds lists of values for the IN statement.
class InListBuilder : ISqlBuilder {

  protected string buildSubTree(parsedSql, string delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, string delim);
  }

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("IN_LIST")) {
      return null;
    }
    
    string mySql = this.buildSubTree(parsedSql, ", ");
    return "(" ~ mySql ~ ")";
  }
}
