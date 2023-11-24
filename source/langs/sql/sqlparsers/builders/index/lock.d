 *  /

  module langs.sql.sqlparsers.builders.index.lock;

import lang.sql;

@safe:

// Builds index lock part of a CREATE INDEX statement.
class IndexLockBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("INDEX_LOCK")) {
      return "";
    }

    string mySql = "";
    foreach (myKey, myValue; parsedSql["sub_tree"]) {
      size_t oldSqlLength = mySql.length;
      mySql ~= this.buildReserved(myValue);
      mySql ~= this.buildConstant(myValue);
      mySql ~= this.buildOperator(myValue);

      if (oldSqlLength == mySql.length) { // No change
        throw new UnableToCreateSQLException("CREATE INDEX lock subtree", myKey, myValue, "expr_type");
      }

      mySql ~= " ";
    }
    return substr(mySql, 0, -1);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildOperator(Json parsedSql) {
    auto myBuilder = new OperatorBuilder();
    return myBuilder.build(parsedSql);
  }
}
