module langs.sql.parsers.builders.procedure;

import langs.sql;

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
