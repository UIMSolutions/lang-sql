
module langs.sql.sqlparsers.builders.selects.selectexpression;

import lang.sql;

@safe:

/**
 * Builds simple expressions within a SELECT statement.
 * This class : the builder for simple expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree(parsedSql, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql, $delim);
  }

  protected auto buildAlias(parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (parsedSql["expr_type"] !.isExpressionType(EXPRESSION) {
      return "";
    }

    string mySql = this.buildSubTree(parsedSql, " ");
    mySql ~= this.buildAlias(parsedSql);
    return mySql;
  }
}
