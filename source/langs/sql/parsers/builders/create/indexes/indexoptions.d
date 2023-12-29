module langs.sql.parsers.builders.create.indexes.indexoptions;

import langs.sql;

@safe:
// Builds index options part of a CREATE INDEX statement.
class CreateIndexOptionsBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (parsedSql["options"].isEmpty) {
      return "";
    }

    string mySql = parsedSql["options"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return " " ~ substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildIndexAlgorithm(aValue);
    result ~= this.buildIndexLock(aValue);
    result ~= this.buildIndexComment(aValue);
    result ~= this.buildIndexParser(aValue);
    result ~= this.buildIndexSize(aValue);
    result ~= this.buildIndexType(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE INDEX options", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildIndexParser(Json parsedSql) {
    auto myBuilder = new IndexParserBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexSize(Json parsedSql) {
    auto myBuilder = new IndexSizeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexType(Json parsedSql) {
    auto myBuilder = new IndexTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexComment(Json parsedSql) {
    auto myBuilder = new IndexCommentBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexAlgorithm(Json parsedSql) {
    auto myBuilder = new IndexAlgorithmBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexLock(Json parsedSql) {
    auto myBuilder = new IndexLockBuilder();
    return myBuilder.build(parsedSql);
  }
}
