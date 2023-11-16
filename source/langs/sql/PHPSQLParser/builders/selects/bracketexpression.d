/**
 * SelectBracketExpressionBuilder.php
 *
 * Builds the bracket expressions within a SELECT statement. */

module langs.sql.PHPSQLParser.builders.selects.bracketexpression;

import lang.sql;

@safe:

/**
 * This class : the builder for bracket expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectBracketExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree($parsed, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build($parsed, $delim);
  }

  protected auto buildAlias($parsed) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build($parsed);
  }

  string build(array$parsed) {
    if ($parsed["expr_type"] != ExpressionType :  : BRACKET_EXPRESSION) {
      return "";
    }
    return "(" ~ this.buildSubTree($parsed, " ") ~ ")" ~ this.buildAlias($parsed);
  }
}
