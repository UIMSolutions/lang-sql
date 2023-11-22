module langs.sql.sqlparsers.builders.selects.bracketexpression;

import lang.sql;

@safe:

/**
 * Builds the b racket expressions within a SELECT statement. */
 * This class : the builder for bracket expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectBracketExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree(parsedSql, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, $delim);
  }

  protected auto buildAlias(parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (parsedSql["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
      return "";
    }
    return "(" ~ this.buildSubTree(parsedSql, " ") ~ ")" ~ this.buildAlias(parsedSql);
  }
}
