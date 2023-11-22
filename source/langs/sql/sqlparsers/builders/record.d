module langs.sql.sqlparsers.builders.record;

import lang.sql;

@safe:

/**
 * Builds the records within the INSERT statement. 
* This class : the builder for the records within INSERT statement.
  * You can overwrite all functions to achieve another handling. */

class RecordBuilder : ISqlBuilder {

  protected auto buildOperator(parsedSql) {
    auto myBuilder = new OperatorBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildFunction(parsedSql) {
    auto myBuilder = new FunctionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildConstant(parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildColRef(parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (parsedSql["expr_type"]!.isExpressionType("RECORD")) {
      return parsedSql.get("base_expr", "");
    }

    string mySql = "";
    foreach (myKey, myValue; parsedSql["data"]) {
      size_t oldSqlLength = mySql.length;
      mySql ~= this.buildConstant(myValue);
      mySql ~= this.buildFunction(myValue);
      mySql ~= this.buildOperator(myValue);
      mySql ~= this.buildColRef(myValue);
      if (oldSqlLength == mySql.length) { // No change
        throw new UnableToCreateSQLException(ExpressionType :  : RECORD, myKey, myValue, "expr_type");
      }

      mySql ~= ", ";
    }
    mySql = substr(mySql, 0, -2);
    return "(" ~ mySql ~ ")";
  }

}
