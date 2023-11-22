module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds reference type within a JOIN. */
 * This class : the references type within a JOIN. 
 * You can overwrite all functions to achieve another handling. */
class RefTypeBuilder {

    auto build(parsedSQL) {
        if (parsedSQL.isEmpty) {
            return "";
        }
        if (parsedSQL == "ON") {
            return " ON ";
        }
        if (parsedSQL == "USING") {
            return " USING ";
        }
        // TODO: add more
        throw new UnsupportedFeatureException(parsedSQL);
    }
}
