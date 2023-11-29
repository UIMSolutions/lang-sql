module langs.sql.sqlparsers.builders.index.comments;

import lang.sql;

@safe:

// Builds index comment part of a CREATE INDEX statement. 
class IndexCommentBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("COMMENT")) {
      return null;
    }
    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildReserved(aValue);
    result ~= this.buildConstant(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE INDEX comment subtree", aKey, aValue, "expr_type");
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
    return myBuilderr.build(parsedSql);
  }
}
