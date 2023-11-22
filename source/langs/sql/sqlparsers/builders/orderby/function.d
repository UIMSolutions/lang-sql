
module lang.sql.parsers.builders;

/**
 * Builds functions within the ORDER-BY part. 
 * This class : the builder for functions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByFunctionBuilder : FunctionBuilder {

    protected auto buildDirection(parsedSQL) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        $sql = super.build(parsedSQL);
        if ($sql != "") {
            $sql ~= this.buildDirection(parsedSQL);
        }
        return $sql;
    }

}
