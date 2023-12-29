module langs.sql.parsers.builders;

import langs.sql;

@safe:
/**
 * This class : the builder for alias references. 
 */
class AliasReferenceBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("ALIAS")) {
      return null;
    }
    string mySql = parsedSql.baseExpression;
    return mySql;
  }
}
