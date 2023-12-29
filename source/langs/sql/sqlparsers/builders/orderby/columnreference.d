module langs.sql.parsers.builders;

import langs.sql;

@safe:
// Builds column references within the ORDER-BY part.
class OrderByColumnReferenceBuilder : ColumnReferenceBuilder {

  string build(Json parsedSql) {
    string result = super.build(parsedSql);
    if (!result.isEmpty) {
      result ~= this.buildDirection(parsedSql);
    }
    return result;
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
