module source.langs.sql.PHPSQLParser.builders.update.update;

import lang.sql;

@safe:

/**
 * Builds the UPDATE statement parts. 
 * This class : the builder for the UPDATE statement parts. 
 * You can overwrite all functions to achieve another handling. */
class UpdateBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $idx) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $idx);
    }

    string build(array $parsed) {
        auto mySql = "";

        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable(myValue, $k);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('UPDATE table list', $k, myValue, "expr_type");
            }
        }
        return 'UPDATE " ~ mySql;
    }
}
