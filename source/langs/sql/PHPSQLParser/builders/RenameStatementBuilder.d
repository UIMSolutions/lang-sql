
module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the RENAME statement */
 * This class : the builder for the RENAME statement. 
 * You can overwrite all functions to achieve another handling. */
class RenameStatementBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto processSourceAndDestTable(myValue) {
        if ("source" !in myValue || !isset(myValue["destination"])) {
            return "";
        }
        return myValue["source"]["base_expr"] ~ " TO " ~ myValue["destination"]["base_expr"] ~ ",";
    }

    string build(array $parsed) {
        auto myRename = $parsed["RENAME"];
        string mySql = "";
        foreach (myKey, myValue; myRename["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.processSourceAndDestTable(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('RENAME subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        mySql = ("RENAME " ~ mySql).strip;
        return (substr(mySql, -1) == "," ? substr(mySql, 0, -1) : mySql);
    }
}

