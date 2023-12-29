module langs.sql.parsers.builders.index.algorithm;

import langs.sql;

@safe:

// Builds index algorithm part of a CREATE INDEX statement.
class IndexAlgorithmBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("INDEX_ALGORITHM")) {
      return null;
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildReserved(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildOperator(aValue);

    if (oldSqlLength == mySql.length) { // No change
      throw new UnableToCreateSQLException("CREATE INDEX algorithm subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
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
    return myBuilderr.build(parsedSql);
  }
}
