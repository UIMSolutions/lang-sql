module lang.sql.parsers.builders;

/**
 * Builds reserved keywords within the ORDER-BY part. 
 * This class : the builder for reserved keywords within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByReservedBuilder : ReservedBuilder {

  protected auto buildDirection(parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }

  auto build(Json parsedSql) {
    string mySql = super.build(parsedSql);
    if (!mySql.isEmpty) {
      mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

}
