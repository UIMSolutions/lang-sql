module lang.sql.parsers.builders;

import lang.sql;

@safe:

// Builds the RENAME statement 
class RenameStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    auto myRename = parsedSql["RENAME"];
    string mySql = myRename["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    mySql = ("RENAME " ~ mySql).strip;
    return (substr(mySql, -1) == "," ? substr(mySql, 0, -1) : mySql);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildReserved(myValue);
    result ~= this.processSourceAndDestTable(myValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("RENAME subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto processSourceAndDestTable(auto[string] myValue) {
    if (myValue.isSet("source") || !myValue.isSet("destination")) {
      return "";
    }

    return myValue["source"].baseExpression ~ " TO " ~ myValue["destination"].baseExpression ~ ",";
  }
}
