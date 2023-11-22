module lang.sql.parsers.builders;

/**
 * Builds column references within the ORDER-BY part.
 * This class : the builder for column references within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByColumnReferenceBuilder : ColumnReferenceBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    string build(Json parsedSQL) {
        $sql = super.build($parsed);
        if ($sql != "") {
            $sql ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
