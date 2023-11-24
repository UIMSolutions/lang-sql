module langs.sql.sqlparsers.builders.show.show;

import lang.sql;

@safe:

/**
 * Builds the SHOW statement. 
 * This class : the builder for the SHOW statement. 
 */
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

  protected auto buildTable(Json parsedSql, $delim) {
    auto myBuilder = new TableBuilder();
    return myBuilder.build(parsedSql, $delim);
  }

  protected auto buildFunction(Json parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildProcedure(Json parsedSql) {
    auto myBuilder = new ProcedureBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildDatabase(Json parsedSql) {
    auto myBuilder = new DatabaseBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildEngine(Json parsedSql) {
    auto myBuilder = new EngineBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

}
