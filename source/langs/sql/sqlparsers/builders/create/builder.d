module langs.sql.sqlparsers.builders.create.builder;

import lang.sql;

@safe:
/**
 * Builds the CREATE statement
 * This class : the builder for the [CREATE] part. You can overwrite
 * all functions to achieve another handling. */
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

  protected auto buildCreateTable(parsedSql) {
    auto myBuilder = new CreateTableBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildCreateIndex(parsedSql) {
    auto myBuilder = new CreateIndexBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildSubTree(parsedSql) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql);
  }
}
