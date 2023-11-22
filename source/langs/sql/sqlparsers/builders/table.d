module langs.sql.sqlparsers.builders.table;

import lang.sql;

@safe:

/**
 * Builds the table name/join options.
 * This class : the builder for the table name and join options.
 * You can overwrite all functions to achieve another handling.
 */
class TableBuilder : ISqlBuilder {

  protected auto buildAlias(parsedSql) {
    AliasBuilder myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildIndexHintList(parsedSql) {
    IndexHintListBuilder myBuilder = new IndexHintListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildJoin(parsedSql) {
    JoinBuilder myBuilder = new JoinBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildRefType(parsedSql) {
    auto myBuilder = new RefTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildRefClause(parsedSql) {
    auto myBuilder = new RefClauseBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql, $index = 0) {
    if (!parsedSql["expr_type"].isExpressionType("TABLE")) {
      return "";
    }

    // Main
    auto mySql = parsedSql["table"];
    mySql ~= this.buildAlias(parsedSql);
    mySql ~= this.buildIndexHintList(parsedSql);

    if ($index != 0) {
      mySql = this.buildJoin(parsedSql["join_type"]).mySql;
      mySql ~= this.buildRefType(parsedSql["ref_type"]);
      mySql ~= parsedSql["ref_clause"] == false ? "" : this.buildRefClause(parsedSql["ref_clause"]);
    }

    return mySql;
  }
}
