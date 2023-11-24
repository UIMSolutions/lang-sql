module langs.sql.sqlparsers.builders.index.algorithm;

import lang.sql;

@safe:

/**
 * Builds index algorithm part of a CREATE INDEX statement.
 * This class : the builder for the index algorithm of CREATE INDEX statement. 
 */
class IndexAlgorithmBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("INDEX_ALGORITHM")) {
      return "";
    }

    string mySql = "";
    foreach (myKey, myValue; parsedSql["sub_tree"]) {
      size_t oldSqlLength = mySql.length;
      mySql ~= this.buildReserved(myValue);
      mySql ~= this.buildConstant(myValue);
      mySql ~= this.buildOperator(myValue);

      if (oldSqlLength == mySql.length) { // No change
        throw new UnableToCreateSQLException("CREATE INDEX algorithm subtree", myKey, myValue, "expr_type");
      }

      mySql ~= " ";
    }
    return substr(mySql, 0, -1);
  }

  protected auto buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildOperator(Json parsedSql) {
    auto myBuilder = new OperatorBuilder();
    return myBuilderr.build(parsedSql);
  }
}
