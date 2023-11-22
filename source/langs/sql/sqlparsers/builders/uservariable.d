module langs.sql.sqlparsers.builders.uservariable;

import lang.sql;

@safe:

/**
 * Builds an user variable. 
 * This class : the builder for an user variable. 
 * You can overwrite all functions to achieve another handling. */
class UserVariableBuilder : ISqlBuilder {

  string build(Json parsedSQL) {
    if (!parsedSQL["expr_type"].isExpressionType("USER_VARIABLE")) {
      return "";
    }

    return parsedSQL["base_expr"];
  }
}
