
module lang.sql.parsers.builders;

/**
 * Builds functions within the ORDER-BY part. 
 * This class : the builder for functions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByFunctionBuilder : FunctionBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    string build(auto[string] parsedSQL) {
        $sql = super.build($parsed);
        if ($sql != "") {
            $sql ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
