module langs.sql.sqlparsers.builders.selects.bracketexpression;

import lang.sql;

@safe:

// Builds the b racket expressions within a SELECT statement. */
class SelectBracketExpressionBuilder : ISqlBuilder {

  protected string buildSubTree(parsedSql, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, $delim);
  }

  protected string buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
      return "";
    }
    return "(" ~ this.buildSubTree(parsedSql, " ") ~ ")" ~ this.buildAlias(parsedSql);
  }
}
