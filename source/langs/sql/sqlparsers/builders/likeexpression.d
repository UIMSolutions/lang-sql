module langs.sql.sqlparsers.builders.likeexpression;

import lang.sql;

@safe:

/**
 * Builds the LIKE keyword within parenthesis. 
 * This class : the builder for the (LIKE) keyword within a 
 * CREATE TABLE statement. There are difference to LIKE (without parenthesis), 
 * the latter is a top-level element of the output array.
 */
class LikeExpressionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("LIKE")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildReserved(myValue);
    result ~= this.buildTable(myValue, 0);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE create-def (like) subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildTable(parsedSql, $index) {
    auto myBuilder = new TableBuilder();
    return myBuilder.build(parsedSql, $index);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }
}
