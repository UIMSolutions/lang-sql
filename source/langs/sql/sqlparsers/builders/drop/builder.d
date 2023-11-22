module langs.sql.sqlparsers.builders.drop.builder;

import lang.sql;

@safe:

/**
 * Builds the CREATE statement 
 * This class : the builder for the [DROP] part. You can overwrite
 * all functions to achieve another handling. */
class DropBuilder : ISqlBuilder {
  protected auto buildSubTree(Json parsedSql) {
    string mySql = "";
    foreach (myKey, myValue; parsedSql["sub_tree"]) {
      auto oldLengthOfSql = mySql.length;
      mySql ~= this.buildReserved(myValue);
      mySql ~= this.buildExpression(myValue);

      if (oldLengthOfSql == mySql.length) {
        throw new UnableToCreateSQLException("DROP subtree", myKey, myValue, "expr_type");
      }

      mySql ~= " ";
    }

    return mySql;
  }

  auto build(Json parsedSql) {
    auto dropSql = parsedSql["DROP"];
    string mySql = this.buildSubTree(dropSql);

    if (dropSql["expr_type"].isExpressionType("INDEX")) {
      mySql ~= "" ~ this.buildDropIndex(parsedSql["INDEX"]) ~ " ";
    }

    return "DROP " ~ substr(mySql, 0, -1);
  }

  protected auto buildDropIndex(Json parsedSql) {
    auto myBuilder = new DropIndexBuilder();

    return myBuilder.build(parsedSql);
  }

  protected auto buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();

    return myBuilder.build(parsedSql);
  }

  protected auto buildExpression(Json parsedSql) {
    auto myBuilder = new DropExpressionBuilder();

    return myBuilder.build(parsedSql);
  }
}
