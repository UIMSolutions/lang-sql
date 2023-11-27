module source.langs.sql.sqlparsers.builders.temptable;

import lang.sql;

@safe:

/**
 * Builds the temporary table name/join options. 
 * This class : the builder for the temporary table name and join options. 
 */
class TempTableBuilder : ISqlBuilder {



  string build(Json parsedSql, size_t index = 0) {
    if (!parsedSql.isExpressionType("TEMPORARY_TABLE")) {
      return "";
    }

    auto mySql = parsedSql["table"];
    mySql ~= this.buildAlias(parsedSql);

    if (index != 0) {
      mySql = this.buildJoin(parsedSql["join_type"]) ~ mySql;
      mySql ~= this.buildRefType(parsedSql["ref_type"]);
      mySql ~= parsedSql["ref_clause"].isEmpty ? "" : this.buildRefClause(parsedSql["ref_clause"]);
    }
    return mySql;
  }

    protected string buildAlias(Json parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildJoin(Json parsedSql) {
    auto myBuilder = new JoinBuilder();
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
