module langs.sql.sqlparsers.builders.uservariable;

import lang.sql;

@safe:

/**
 * Builds an user variable. 
 * This class : the builder for an user variable. 
 *  */
class UserVariableBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql["expr_type"].isExpressionType("USER_VARIABLE")) {
      return "";
    }

    return parsedSql["base_expr"];
  }
}
