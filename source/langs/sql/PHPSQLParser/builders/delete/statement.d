module source.langs.sql.PHPSQLParser.builders.delete.statement;

import lang.sql;

@safe:
/**
 * Builds the DELETE statement 
 * This class : the builder for the whole Delete statement. You can overwrite
 * all functions to achieve another handling. */
class DeleteStatementBuilder : ISqlBuilder {
  protected auto buildWhere($parsed) {
    auto myBuilder = new WhereBuilder();
    return myBuilder.build($parsed);
  }

  protected auto buildFrom($parsed) {
    auto myBuilder = new FromBuilder();
    return myBuilder.build($parsed);
  }

  protected auto buildDelete($parsed) {
    auto myBuilder = new DeleteBuilder();
    return myBuilder.build($parsed);
  }

  string build(array $parsed) {
    string mySql = this.buildDelete($parsed["DELETE"]) ~ " " ~ this.buildFrom($parsed["FROM"]);
    if (isset($parsed["WHERE"])) {
      mySql ~= " " ~ this.buildWhere($parsed["WHERE"]);
    }
    return mySql;
  }

}
