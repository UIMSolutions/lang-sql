
/**
 * InvalidParameterException.php
 *
 * This file : the InvalidParameterException class which is used within the
 * SqlParser package.
 */

module source.langs.sql.PHPSQLParser.exceptions.invalidparameter;

import lang.sql;

@safe:

/**
 * This exception will occur in the parser, if the given SQL statement
 * is not a String type. */
class InvalidParameterException : InvalidArgumentException {

    protected $argument;

    this($argument) {
        this.argument = $argument;
        super.("no SQL string to parse: \n" . $argument, 10);
    }

    auto getArgument() {
        return this.argument;
    }
}

?>
