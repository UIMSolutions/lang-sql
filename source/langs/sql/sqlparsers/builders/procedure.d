module langs.sql.sqlparsers.builders.procedure;

import lang.sql;

@safe:

// Builds the procedures within the SHOW statement. 
class ProcedureBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("PROCEDURE")) {
      return null;
    }
    
    return parsedSql.baseExpression;
  }
}
