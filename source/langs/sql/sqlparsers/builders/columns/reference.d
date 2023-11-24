module langs.sql.sqlparsers.builders.columns.reference;

import lang.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("COLREF")) {
      return "";
    }

    string mySql = parsedSql["base_expr"];
    mySql ~= this.buildAlias(parsedSql);
    return mySql;
  }

  protected auto buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

}
