
module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the RENAME statement */
 * This class : the builder for the RENAME statement. 
 *  */
class RenameStatementBuilder : ISqlBuilder {

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto processSourceAndDestTable(auto[string] myValue) {
        if (myValue.isSet("source") || !myValue.isSet("destination")) {
            return "";
        }
        return myValue["source"]["base_expr"] ~ " TO " ~ myValue["destination"]["base_expr"] ~ ",";
    }

    string build(Json parsedSql) {
        auto myRename = parsedSql["RENAME"];
        string mySql = "";
        foreach (myKey, myValue; myRename["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.processSourceAndDestTable(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("RENAME subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        mySql = ("RENAME " ~ mySql).strip;
        return (substr(mySql, -1) == "," ? substr(mySql, 0, -1) : mySql);
    }
}

