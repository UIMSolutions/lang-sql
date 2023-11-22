
module lang.sql.parsers.builders;

/**
 * Builds functions within the ORDER-BY part. 
 * This class : the builder for functions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByFunctionBuilder : FunctionBuilder {

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
