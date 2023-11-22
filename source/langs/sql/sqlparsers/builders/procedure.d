
module langs.sql.sqlparsers.builders.procedure;

import lang.sql;

@safe:

/**
 * Builds the procedures within the SHOW statement. 
 * This class : the builder for a procedure within SHOW statement. 
 *  */
class ProcedureBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql["expr_type"].isExpressionType("PROCEDURE")) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
