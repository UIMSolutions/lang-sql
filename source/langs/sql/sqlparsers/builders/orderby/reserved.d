module lang.sql.parsers.builders;

/**
 * Builds reserved keywords within the ORDER-BY part. 
 * This class : the builder for reserved keywords within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByReservedBuilder : ReservedBuilder {

  protected auto buildDirection(parsedSQL) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSQL);
  }

  auto build(Json parsedSQL) {
    string mySql = super.build(parsedSQL);
    if (!mySql.isEmpty) {
      mySql ~= this.buildDirection(parsedSQL);
    }
    return mySql;
  }

}
