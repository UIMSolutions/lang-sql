module langs.sql.sqlparsers.builders.groupby.alias;

import lang.sql;

@safe:

// Builds an alias within a GROUP-BY clause.
class GroupByAliasBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("ALIAS")) {
      return null;
    }
    return parsedSql.baseExpression;
  }
}
