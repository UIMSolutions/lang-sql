module langs.sql.sqlparsers.builders.update.update;

import lang.sql;

@safe:

// Builds the UPDATE statement parts. 
class UpdateBuilder : ISqlBuilder {

  protected string buildTable(parsedSql, string idx) {
    auto myBuilder = new TableBuilder();
    return myBuilder.build(parsedSql, idx);
  }

  string build(Json parsedSql) {
    string mySql = parsedSql.byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;
         
    return "UPDATE " ~ mySql;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildTable(aValue, aKey);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("UPDATE table list", aKey, aValue, "expr_type");
    }

    return result;
  }
}
