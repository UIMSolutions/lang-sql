module langs.sql.sqlparsers.builders.insert.statement;

import lang.sql;

@safe:

// Builds the INSERT statement
class InsertStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    // TODO: are there more than one tables possible (like [INSERT][1])
    string mySql = this.buildINSERT(parsedSql["INSERT"]);

    if (parsedSql.isSet("VALUES")) {
      mySql ~= " " ~ this.buildValues(parsedSql["VALUES"]);
    }
    if (parsedSql.isSet("SET")) {
      mySql ~= " " ~ this.buildSet(parsedSql["SET"]);
    }
    if (parsedSql.isSet("SELECT")) {
      mySql ~= " " ~ this.buildSelect(parsedSql);
    }

    return mySql;
  }

  protected string buildValues(Json parsedSql) {
    auto myBuilder = new ValuesBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildINSERT(Json parsedSql) {
    auto myBuilder = new InsertBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSelect(Json parsedSql) {
    auto myBuilder = new SelectStatementBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSet(Json parsedSql) {
    auto myBuilder = new SetBuilder();
    return myBuilder.build(parsedSql);
  }

}
