module langs.sql.sqlparsers.builders.record;

import lang.sql;

@safe:

/**
 * Builds the records within the INSERT statement. */
* This class : the builder for the records within INSERT statement.
  * You can overwrite all functions to achieve another handling. *  /
  class RecordBuilder : ISqlBuilder {

    protected auto buildOperator(parsedSQL) {
      auto myBuilder = new OperatorBuilder();
      return myBuilder.build(parsedSQL);
    }

    protected auto buildFunction(parsedSQL) {
      auto myBuilder = new FunctionBuilder();
      return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
      auto myBuilder = new ConstantBuilder();
      return myBuilder.build(parsedSQL);
    }

    protected auto buildColRef(parsedSQL) {
      auto myBuilder = new ColumnReferenceBuilder();
      return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
      if (parsedSQL["expr_type"] !.isExpressionType(RECORD) {
        return parsedSQL.get("base_expr", "");
      }
      
      string mySql = "";
      foreach (myKey, myValue; parsedSQL["data"]) {
        size_t oldSqlLength = mySql.length;
        mySql ~= this.buildConstant(myValue);
        mySql ~= this.buildFunction(myValue);
        mySql ~= this.buildOperator(myValue);
        mySql ~= this.buildColRef(myValue);

        if (oldSqlLength == mySql.length) { // No change
          throw new UnableToCreateSQLException(ExpressionType : : RECORD, myKey, myValue, "expr_type");
        }

        mySql ~= ", ";
      }
      mySql = substr(mySql, 0,  - 2);
      return "(" ~ mySql ~ ")";
    }

  }
