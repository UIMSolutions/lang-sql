module lang.sql.parsers.builders;

/**
 * Builds column references within the ORDER-BY part.
 * This class : the builder for column references within the ORDER-BY part. 
 * It must contain the direction. 
 */
class OrderByColumnReferenceBuilder : ColumnReferenceBuilder {

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    string result = super.build(parsedSql);
    if (result != "") {
      result ~= this.buildDirection(parsedSql);
    }
    return result;
  }

}
