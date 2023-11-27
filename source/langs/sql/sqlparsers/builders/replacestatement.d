module langs.sql.sqlparsers.builders.replacestatement;

// Builds the REPLACE statement 
class ReplaceStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    // TODO: are there more than one tables possible (like [REPLACE][1])
    string mySql = this.buildREPLACE(parsedSql["REPLACE"]);
    mySql ~= parsedSql.isSet("VALUES") ? " " ~ this.buildVALUES(parsedSql["VALUES"]) : "";
    mySql ~= parsedSql.isSet("SET") ? " " ~ this.buildSET(parsedSql["SET"]) : "";
    mySql ~= parsedSql.isSet("SELECT") ? " " ~ this.buildSELECT(parsedSql) : "";

    return mySql;
  }

  protected string buildVALUES(Json parsedSql) {
    auto myBuilder = new ValuesBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildREPLACE(Json parsedSql) {
    auto myBuilder = new ReplaceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSELECT(Json parsedSql) {
    auto myBuilder = new SelectStatementBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSET(Json parsedSql) {
    auto myBuilder = new SetBuilder();
    return myBuilder.build(parsedSql);
  }
}
