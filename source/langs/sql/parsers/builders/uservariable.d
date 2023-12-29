module langs.sql.parsers.builders.uservariable;

import langs.sql;

@safe:

// Builds an user variable. 
class UserVariableBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("USER_VARIABLE")) {
      return "";
    }

    return parsedSql.baseExpression;
  }
}
