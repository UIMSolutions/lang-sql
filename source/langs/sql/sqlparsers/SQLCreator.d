module langs.sql.sqlparsers.sqlcreator;

import lang.sql;

@safe:

// A creator, which generates SQL from the output of SqlParser.
class SqlCreator {

  string _createdSql;

  this(Json aParsed = json(null)) {
    if (!aParsed.isNull) {
      this.create(aParsed);
    }
  }

  string create(Json aParsed) {
    string myKey = key(aParsed);
    switch (myKey) {

    case "UNION":
      auto myBuilder = new UnionStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "UNION ALL":
      auto myBuilder = new UnionAllStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "SELECT":
      auto myBuilder = new SelectStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "INSERT":
      auto myBuilder = new InsertStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "REPLACE":
      auto myBuilder = new ReplaceStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "DELETE":
      auto myBuilder = new DeleteStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "TRUNCATE":
      auto myBuilder = new TruncateStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "UPDATE":
      auto myBuilder = new UpdateStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "RENAME":
      auto myBuilder = new RenameStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "SHOW":
      auto myBuilder = new ShowStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "CREATE":
      auto myBuilder = new CreateStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "BRACKET":
      auto myBuilder = new BracketStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "DROP":
      auto myBuilder = new DropStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    case "ALTER":
      auto myBuilder = new AlterStatementBuilder();
      _createdSql = myBuilder.build(aParsed);
      break;
    default:
      throw new UnsupportedFeatureException(myKey);
      break;
    }
    return _createdSql;
  }
}
