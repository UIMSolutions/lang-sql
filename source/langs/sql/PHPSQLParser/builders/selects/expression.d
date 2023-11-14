
module source.langs.sql.PHPSQLParser.builders.selects.selectexpression;

import lang.sql;

@safe:

/**
 * Builds simple expressions within a SELECT statement.
 * This class : the builder for simple expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree($parsed, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build($parsed, $delim);
  }

  protected auto buildAlias($parsed) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build($parsed);
  }

  auto build(array $parsed) {
    if ($parsed["expr_type"] != ExpressionType :  : EXPRESSION) {
      return "";
    }
    
    auto mySql = this.buildSubTree($parsed, " ");
    mySql ~= this.buildAlias($parsed);
    return mySql;
  }
}
