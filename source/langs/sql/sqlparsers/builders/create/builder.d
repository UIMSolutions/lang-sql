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

  string build(Json parsedSQL) {
    if (!parsedSQL.isObject) {
      return null;
    }

    auto myCreate = parsedSQL["CREATE"];
    string mySql = this.buildSubTree(myCreate);

    if (myCreate["expr_type"].isExpressionType("TABLE")
      || myCreate["expr_type"].isExpressionType("TEMPORARY_TABLE")) {
      mySql ~= " " ~ this.buildCreateTable(parsedSQL["TABLE"]);
    }
    if (myCreate["expr_type"].isExpressionType("INDEX")) {
      mySql ~= " " ~ this.buildCreateIndex(parsedSQL["INDEX"]);
    }

    // TODO: add more expr_types here (like VIEW), if available in parser output
    return "CREATE " ~ mySql;
  }

  protected auto buildCreateTable(parsedSQL) {
    auto myBuilder = new CreateTableBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildCreateIndex(parsedSQL) {
    auto myBuilder = new CreateIndexBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildSubTree(parsedSQL) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSQL);
  }
}
