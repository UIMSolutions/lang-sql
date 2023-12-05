module langs.sql.interfaces.processor;

import lang.sql;

@safe:

interface IProcessor {
    /**
     * This auto : the main functionality of a processor class.
     * Always use default valuses for additional parameters within overridden functions.
     */
    auto process(mytokens);

    // this auto splits up a SQL statement into easy to "parse" tokens for the SQL processor
    auto splitSQLIntoTokens(sqlString);


    auto processComment(myexpression);

    // translates an array of objects into an associative array
    auto toArray(mytokenList);
}
