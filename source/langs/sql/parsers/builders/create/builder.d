module langs.sql.parsers.builders.create.builder;

import langs.sql;

@safe:
// Builds the CREATE statement
class CreateBuilder : ISqlBuilder {
  this() {
  }

  string build(Json parsedSql) {
    if (!parsedSql.isObject) {
      return null;
    }

    auto myCreate = parsedSql["CREATE"];
    string mySql = this.buildSubTree(myCreate);

    if (myCreate.isExpressionType("TABLE")
      || myCreate.isExpressionType("TEMPORARY_TABLE")) {
     mySql ~= " " ~ this.buildCreateTable(parsedSql["TABLE"]);
    }
    if (myCreate.isExpressionType("INDEX")) {
     mySql ~= " " ~ this.buildCreateIndex(parsedSql["INDEX"]);
    }

    // TODO: add more expr_types here (like VIEW), if available in parser output
    return "CREATE " ~ mySql;
  }

  protected string buildCreateTable(Json parsedSql) {
    auto myBuilder = new CreateTableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildCreateIndex(Json parsedSql) {
    auto myBuilder = new CreateIndexBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildSubTree(Json parsedSql) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql);
  }
}
