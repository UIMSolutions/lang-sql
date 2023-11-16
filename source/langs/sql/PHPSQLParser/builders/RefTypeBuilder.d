module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds reference type within a JOIN. */
 * This class : the references type within a JOIN. 
 * You can overwrite all functions to achieve another handling. */
class RefTypeBuilder {

    auto build($parsed) {
        if ($parsed.isEmpty) {
            return "";
        }
        if ($parsed == 'ON') {
            return " ON ";
        }
        if ($parsed == 'USING') {
            return " USING ";
        }
        // TODO: add more
        throw new UnsupportedFeatureException($parsed);
    }
}
