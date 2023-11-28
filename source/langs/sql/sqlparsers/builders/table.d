module langs.sql.sqlparsers.builders.table;

import lang.sql;

@safe:

// Builds the table name/join options.
class TableBuilder : ISqlBuilder {

  string build(Json parsedSql, size_t index = 0) {
    if (!parsedSql.isExpressionType("TABLE")) {
      return "";
    }

    // Main
    auto mySql = parsedSql["table"];
    mySql ~= this.buildAlias(parsedSql);
    mySql ~= this.buildIndexHintList(parsedSql);

    if (index > 0) {
      mySql = this.buildJoin(parsedSql["join_type"]) ~ mySql;
      mySql ~= this.buildRefType(parsedSql["ref_type"]);
      mySql ~= parsedSql["ref_clause"].isEmpty ? "" : this.buildRefClause(parsedSql["ref_clause"]);
    }

    return mySql;
  }
  protected string buildAlias(Json parsedSql) {
    AliasBuilder myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexHintList(Json parsedSql) {
    IndexHintListBuilder myBuilder = new IndexHintListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildJoin(Json parsedSql) {
    JoinBuilder myBuilder = new JoinBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildRefType(Json parsedSql) {
    auto myBuilder = new RefTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildRefClause(Json parsedSql) {
    auto myBuilder = new RefClauseBuilder();
    return myBuilder.build(parsedSql);
  }

}
