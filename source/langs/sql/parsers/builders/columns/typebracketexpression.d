module langs.sql.parsers.builders.columns.typebracketexpression;

import langs.sql;

@safe:
// Builds the bracket expressions within a column type.
class ColumnTypeBracketExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
      return "";
    }
    string mySql = this.buildSubTree(parsedSql, ",");
   mySql = "(" ~ mySql ~ ")";
    return mySql;
  }

  protected string buildSubTree(parsedSql, string delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, delim);
  }
}
