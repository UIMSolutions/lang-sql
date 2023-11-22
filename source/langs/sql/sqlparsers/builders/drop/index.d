module langs.sql.sqlparsers.builders.drop.index;

import lang.sql;

@safe:
/**
 * This class : the builder for the DROP INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class DropIndexBuilder : IBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isSet("name")) {
      debug writeln("WARNING: In DropIndexBuilder: 'name' is missing.");
      return null;
    }

    string mySql = parsedSql["name"].strip;
    mySql ~= " " ~ this.buildIndexTable(parsedSql);
    return mySql.strip;
  }

  protected auto buildIndexTable(Json parsedSql) {
    auto myBuilder = new DropIndexTableBuilder();
    return myBuilder.build(parsedSql);
  }
}
