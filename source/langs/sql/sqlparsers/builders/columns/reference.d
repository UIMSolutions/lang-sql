module langs.sql.sqlparsers.builders.columns.reference;

import langs.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("COLREF")) {
      return "";
    }

    string mySql = parsedSql.baseExpression;
   mySql ~= this.buildAlias(parsedSql);
    return mySql;
  }

  protected string buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

}
