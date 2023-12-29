module langs.sql.sqlparsers.builders.show.show;

import langs.sql;

@safe:

// Builds the SHOW statement. 
class ShowBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    auto showSql = parsedSql["SHOW"];

    string result = showSql.byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    result = "SHOW " ~ substr(result, 0, -1);
    return result;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildReserved(myValue);
    result ~= this.buildConstant(myValue);
    result ~= this.buildEngine(myValue);
    result ~= this.buildDatabase(myValue);
    result ~= this.buildProcedure(myValue);
    result ~= this.buildFunction(myValue);
    result ~= this.buildTable(myValue, 0);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("SHOW", myKey, myValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildTable(Json parsedSql, string delim) {
    auto myBuilder = new TableBuilder();
    return myBuilder.build(parsedSql, delim);
  }

  protected string buildFunction(Json parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildProcedure(Json parsedSql) {
    auto myBuilder = new ProcedureBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildDatabase(Json parsedSql) {
    auto myBuilder = new DatabaseBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildEngine(Json parsedSql) {
    auto myBuilder = new EngineBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

}
