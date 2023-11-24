module lang.sql.parsers.builders;

/**
 * Builds reserved keywords within the ORDER-BY part. 
 * This class : the builder for reserved keywords within the ORDER-BY part. 
 * It must contain the direction. 
 */
class OrderByReservedBuilder : ReservedBuilder {

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    string mySql = super.build(parsedSql);
    if (!mySql.isEmpty) {
      mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

}
