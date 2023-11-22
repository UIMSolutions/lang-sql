module source.langs.sql.sqlparsers.builders.temptable;

import lang.sql;

@safe:

/**
 * Builds the temporary table name/join options. 
 * This class : the builder for the temporary table name and join options. 
 *  */
class TempTableBuilder : ISqlBuilder {

  protected auto buildAlias(parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildJoin(parsedSql) {
    auto myBuilder = new JoinBuilder();
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
    if (!parsedSql["expr_type"].isExpressionType("TEMPORARY_TABLE")) {
      return "";
    }

    auto mySql = parsedSql["table"];
    mySql ~= this.buildAlias(parsedSql);

    if ($index != 0) {
      mySql = this.buildJoin(parsedSql["join_type"]) ~ mySql;
      mySql ~= this.buildRefType(parsedSql["ref_type"]);
      mySql ~= parsedSql["ref_clause"] == false ? "" : this.buildRefClause(parsedSql["ref_clause"]);
    }
    return mySql;
  }
}
