module langs.sql.parsers.builders;

import langs.sql;

@safe:
// Builds reserved keywords within the ORDER-BY part. 
class OrderByReservedBuilder : ReservedBuilder {

  string build(Json parsedSql) {
    string mySql = super.build(parsedSql);
    if (!mySql.isEmpty) {
     mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
