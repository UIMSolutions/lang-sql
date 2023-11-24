module source.langs.sql.sqlparsers.builders.temptable;

import lang.sql;

@safe:

/**
 * Builds the temporary table name/join options. 
 * This class : the builder for the temporary table name and join options. 
 */
class TempTableBuilder : ISqlBuilder {

  protected auto buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildJoin(Json parsedSql) {
    auto myBuilder = new JoinBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildRefType(Json parsedSql) {
    auto myBuilder = new RefTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildRefClause(Json parsedSql) {
    auto myBuilder = new RefClauseBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql, $index = 0) {
    if (!parsedSql.isExpressionType("TEMPORARY_TABLE")) {
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
