module lang.sql.parsers.builders;

/**
 * Builds column references within the ORDER-BY part.
 * This class : the builder for column references within the ORDER-BY part. 
 * It must contain the direction. 
 *  */
class OrderByColumnReferenceBuilder : ColumnReferenceBuilder {

    protected auto buildDirection(parsedSql) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        $sql = super.build(parsedSql);
        if ($sql != "") {
            $sql ~= this.buildDirection(parsedSql);
        }
        return $sql;
    }

}
