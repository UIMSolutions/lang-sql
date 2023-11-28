module lang.sql.parsers.builders;
import lang.sql;

@safe:
// Builds the TRUNCATE statement 
class TruncateStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = this.buildTruncate(parsedSql);
    // mySql ~= " " ~ this.buildTruncate(parsedSql) // Uncomment when parser fills in expr_type=table

    return mySql;
  }

  protected string buildTruncate(Json parsedSql) {
    auto myBuilder = new TruncateBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildFROM(Json parsedSql) {
    auto myBuilder = new FromBuilder();
    return myBuilder.build(parsedSql);
  }
}
