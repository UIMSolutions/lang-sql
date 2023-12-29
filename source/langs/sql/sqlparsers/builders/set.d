module langs.sql.sqlparsers.builders.set;

import langs.sql;

@safe:

// Builds the SET part of the INSERT statement.
class SetBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = parsedSql.myKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return "SET " ~ substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildSetExpression(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("SET", aKey, aValue, "expr_type");
    }

    result ~= ",";
    return result;
  }

  protected string buildSetExpression(Json parsedSql) {
    auto myBuilder = new SetExpressionBuilder();
    return myBuilder.build(parsedSql);
  }
}
