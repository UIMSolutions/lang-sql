module langs.sql.sqlparsers.sqlparser;

import lang.sql;

@safe:

// A pure PHP SQL (non validating) parser w/ focus on MySQL dialect of SQL
class SqlParser {

    private Json _parsed;

    private Options _options;

    /**
     * Constructor. It simply calls the parse() function.
     * Use the variable  _parsed to get the output.
     *
     * @param bool calcPositions True, if the output should contain [position], false otherwise.
     * @param array myoptions
     */
    this(string sqlStatement = null, bool calcPositions = false, Json someOptions = Json(null)) {
        _options = new Options(myoptions);

        if (!sqlStatement.isNull) {
            this.parse(sqlStatement, calcPositions);
        }
    }

    /**
     * It parses the given SQL statement and generates a detailled output array for every part of the statement. The method can
     * also generate [position] fields within the output, which hold the character position for every statement part. The calculation
     * of the positions needs some time, if you don"t need positions in your application, set the parameter to false.
     *
     * @param boolean hasCalcPositions True, if the output should contain [position], false otherwise.
     * Returns -  An associative array with all meta information about the SQL statement.
     */
    Json parse(string sqlStatement, bool hasCalcPositions = false) {

        auto myProcessor = new DefaultProcessor(_options);
        auto myQueries = myProcessor.process(sqlStatement);

        // calc the positions of some important tokens
        if (hasCalcPositions) {
            auto myCalculator = new PositionCalculator();
           myQueries = myCalculator.setPositionsWithinSQL(sqlStatement, myQueries);
        }

        // store the parsed queries
        _parsed = myQueries;
        return _parsed;
    }

    /**
     * Add a custom auto to the parser.  no return value
     * tokenName The name of the auto to add
     */
    void addCustomFunction(string tokenName) {
        SqlParserConstants::getInstance().addCustomFunction(tokenName);
    }

    /**
     * Remove a custom auto from the parser.  no return value
     * tokenName The name of the auto to remove
     */
    void removeCustomFunction(string tokenName) {
        SqlParserConstants::getInstance().removeCustomFunction(tokenName);
    }

    /**
     * Returns the list of custom functions
     *
     * @return array Returns an array of all custom functions
     */
    auto getCustomFunctions() {
        return SqlParserConstants::getInstance().getCustomFunctions();
    }
}
