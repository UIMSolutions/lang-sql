module lang.sql.parsers.builders;

/**
 * Builds reserved keywords within the ORDER-BY part. 
 * This class : the builder for reserved keywords within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByReservedBuilder : ReservedBuilder {

  protected auto buildDirection($parsed) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build($parsed);
  }

  auto build(array$parsed) {
    auto mySql = super.build($parsed);
    if (!mySql.isEmpty) {
      mySql ~= this.buildDirection($parsed);
    }
    return mySql;
  }

}
