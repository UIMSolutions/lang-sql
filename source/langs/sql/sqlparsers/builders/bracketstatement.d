module langs.sql.parsers.builders;

import langs.sql;

@safe:
// Builds the parentheses around a statement. */
class BracketStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = parsedSql["BRACKET"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return (mySql ~ " " ~ this.buildSelectStatement(parsedSql).strip).strip;
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildSelectBracketExpression(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("BRACKET", aKey, aValue, "expr_type");
    }

    return result;
  }

  protected string buildSelectBracketExpression(Json parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql, " ");
  }

  protected string buildSelectStatement(Json parsedSql) {
    auto myBuilder = new SelectStatementBuilder();
    return myBuilder.build(parsedSql);
  }
}
