module langs.sql.sqlparsers.sqlcreator;

import lang.sql;

@safe:

// A creator, which generates SQL from the output of SqlParser.
class PHPSQLCreator {

    $created;

    this(aParsed = false) {
        if (aParsed) {
            this.create(aParsed);
        }
    }

    auto create(Json aParsed) {
        $k = key(aParsed);
        switch ($k) {

        case "UNION":
			auto myBuilder = new UnionStatementBuilder();
			this.created = myBuilder.build(aParsed);
			break;
        case "UNION ALL":
            auto myBuilder = new UnionAllStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "SELECT":
            auto myBuilder = new SelectStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "INSERT":
            auto myBuilder = new InsertStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "REPLACE":
            auto myBuilder = new ReplaceStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "DELETE":
            auto myBuilder = new DeleteStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "TRUNCATE":
            auto myBuilder = new TruncateStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "UPDATE":
            auto myBuilder = new UpdateStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "RENAME":
            auto myBuilder = new RenameStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "SHOW":
            auto myBuilder = new ShowStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "CREATE":
            auto myBuilder = new CreateStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "BRACKET":
            auto myBuilder = new BracketStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "DROP":
            auto myBuilder = new DropStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        case "ALTER":
            auto myBuilder = new AlterStatementBuilder();
            this.created = myBuilder.build(aParsed);
            break;
        default:
            throw new UnsupportedFeatureException($k);
            break;
        }
        return this.created;
    }
}
