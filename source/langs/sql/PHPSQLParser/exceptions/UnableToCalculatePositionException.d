
/**
 * UnableToCalculatePositionException.php
 *
 * This file : the UnableToCalculatePositionException class which is used within the
 * SqlParser package.
 */

module lang.sql.parsers.exceptions;

import lang.sql;

@safe:

/**
 * This exception will occur, if the PositionCalculator can not find the token 
 * defined by a base_expr field within the original SQL statement. Please create 
 * an issue in such a case, it is an application error. */
class UnableToCalculatePositionException : Exception {

    protected $needle;
    protected $haystack;

    this($needle, $haystack) {
        this.needle = $needle;
        this.haystack = $haystack;
        super.("cannot calculate position of " . $needle . " within " . $haystack, 5);
    }

    auto getNeedle() {
        return this.needle;
    }

    auto getHaystack() {
        return this.haystack;
    }
}

?>
