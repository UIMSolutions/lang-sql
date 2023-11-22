module langs.sql.sqlparsers.builders.table;

import lang.sql;

@safe:

/**
 * Builds the table name/join options.
 * This class : the builder for the table name and join options.
 * You can overwrite all functions to achieve another handling.
 */
class TableBuilder : ISqlBuilder {

  protected auto buildAlias(parsedSQL) {
    AliasBuilder myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildIndexHintList(parsedSQL) {
    IndexHintListBuilder myBuilder = new IndexHintListBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildJoin(parsedSQL) {
    JoinBuilder myBuilder = new JoinBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildRefType(parsedSQL) {
    auto myBuilder = new RefTypeBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildRefClause(parsedSQL) {
    auto myBuilder = new RefClauseBuilder();
    return myBuilder.build(parsedSQL);
  }

  string build(Json parsedSQL, $index = 0) {
    if (!parsedSQL["expr_type"].isExpressionType("TABLE")) {
      return "";
    }

    // Main
    auto mySql = parsedSQL["table"];
    mySql ~= this.buildAlias(parsedSQL);
    mySql ~= this.buildIndexHintList(parsedSQL);

    if ($index != 0) {
      mySql = this.buildJoin(parsedSQL["join_type"]).mySql;
      mySql ~= this.buildRefType(parsedSQL["ref_type"]);
      mySql ~= parsedSQL["ref_clause"] == false ? "" : this.buildRefClause(parsedSQL["ref_clause"]);
    }

    return mySql;
  }
}
