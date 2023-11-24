module langs.sql.sqlparsers.builders.drop.index;

import lang.sql;

@safe:
// This class : the builder for the DROP INDEX statement.
class DDropIndexBuilder : IBuilder {
  this() {
  }

  string build(Json parsedSql) {
    if (!parsedSql.isSet("name")) {
      debug writeln("WARNING: In DropIndexBuilder: 'name' is missing.");
      return null;
    }

    string mySql = parsedSql["name"].strip;
    mySql ~= " " ~ this.buildIndexTable(parsedSql);
    return mySql.strip;
  }

  protected string buildIndexTable(Json parsedSql) {
    auto myBuilder = new DropIndexTableBuilder();
    return myBuilder.build(parsedSql);
  }
}

auto DropIndexBuilder() {
  return new DDropIndexBuilder;
}
