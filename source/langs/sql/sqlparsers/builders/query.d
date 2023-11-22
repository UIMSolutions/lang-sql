module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the SELECT statements within parentheses. 
 * This class : the builder for queries within parentheses (no subqueries). 
 *  */
class QueryBuilder : ISqlBuilder {

  string build(Json parsedSql, anIndex = 0) {
    if (!parsedSql.isExpressionType("QUERY")) {
      return "";
    }

    // TODO: should we add a numeric level (0) between sub_tree and SELECT?
    auto mySql = this.buildSelectStatement(parsedSql["sub_tree"]);
    mySql ~= this.buildAlias(parsedSql);

    if (anIndex != 0) {
      mySql = this.buildJoin(parsedSql["join_type"]).mySql;
      mySql ~= this.buildRefType(parsedSql["ref_type"]);
      mySql ~= parsedSql["ref_clause"] == false ? "" : this.buildRefClause(parsedSql["ref_clause"]);
    }
    return mySql;
  }

  protected auto buildRefClause(parsedSql) {
    auto myBuilder = new RefClauseBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildRefType(parsedSql) {
    auto myBuilder = new RefTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildJoin(parsedSql) {
    auto myBuilder = new JoinBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildAlias(parsedSql) {
    auto myBuilder = new AliasBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildSelectStatement(parsedSql) {
    auto myBuilder = new SelectStatementBuilder();
    return myBuilder.build(parsedSql);
  }
}
