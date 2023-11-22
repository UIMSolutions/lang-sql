
module langs.sql.sqlparsers.builders.selects.selectexpression;

import lang.sql;

@safe:

/**
 * Builds simple expressions within a SELECT statement.
 * This class : the builder for simple expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling. */
class SelectExpressionBuilder : ISqlBuilder {

  protected auto buildSubTree(parsedSQL, $delim) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSQL, $delim);
  }

  protected auto buildAlias(parsedSQL) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSQL);
  }

  string build(Json parsedSQL) {
    if (parsedSQL["expr_type"] !.isExpressionType(EXPRESSION) {
      return "";
    }

    string mySql = this.buildSubTree(parsedSQL, " ");
    mySql ~= this.buildAlias(parsedSQL);
    return mySql;
  }
}
