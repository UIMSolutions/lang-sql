module langs.sql.sqlparsers.builders.selects.bracketexpression;

import lang.sql;

@safe:

/**
 * Builds the b racket expressions within a SELECT statement. */
 * This class : the builder for bracket expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectBracketExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree(parsedSQL, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSQL, $delim);
  }

  protected auto buildAlias(parsedSQL) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSQL);
  }

  string build(Json parsedSQL) {
    if (parsedSQL["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
      return "";
    }
    return "(" ~ this.buildSubTree(parsedSQL, " ") ~ ")" ~ this.buildAlias(parsedSQL);
  }
}
