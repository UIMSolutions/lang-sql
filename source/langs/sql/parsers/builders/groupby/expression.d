module langs.sql.sqlparsers.builders.groupby.expression;

import langs.sql;

@safe:

// Builds an expression within a GROUP-BY clause.
class GroupByExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("EXPRESSION")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

   mySql = substr(mySql, 0, -1);
    return mySql;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildColRef(aValue);
    result ~= this.buildReserved(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("GROUP expression subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilderr.build(parsedSql);
  }
}
