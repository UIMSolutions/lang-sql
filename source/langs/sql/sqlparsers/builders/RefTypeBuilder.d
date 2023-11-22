module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds reference type within a JOIN. */
 * This class : the references type within a JOIN. 
 *  */
class RefTypeBuilder {

    auto build(Json parsedSql) {
        if (parsedSql.isEmpty) {
            return "";
        }
        if (parsedSql == "ON") {
            return " ON ";
        }
        if (parsedSql == "USING") {
            return " USING ";
        }
        // TODO: add more
        throw new UnsupportedFeatureException(parsedSql);
    }
}
