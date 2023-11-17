module langs.sql.sqlparsers.SQLCreator;

import lang.sql;

@safe:;

// A creator, which generates SQL from the output of SqlParser.
// This class generates SQL from the output of the SqlParser. 
class PHPSQLCreator {

    $created;

    this($parsed = false) {
        if ($parsed) {
            this.create($parsed);
        }
    }

    auto create($parsed) {
        $k = key($parsed);
        switch ($k) {

        case 'UNION':
			auto myBuilder = new UnionStatementBuilder();
			this.created = myBuilder.build($parsed);
			break;
        case 'UNION ALL':
            auto myBuilder = new UnionAllStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'SELECT':
            auto myBuilder = new SelectStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'INSERT':
            auto myBuilder = new InsertStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'REPLACE':
            auto myBuilder = new ReplaceStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'DELETE':
            auto myBuilder = new DeleteStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'TRUNCATE':
            auto myBuilder = new TruncateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'UPDATE':
            auto myBuilder = new UpdateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'RENAME':
            auto myBuilder = new RenameStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'SHOW':
            auto myBuilder = new ShowStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'CREATE':
            auto myBuilder = new CreateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'BRACKET':
            auto myBuilder = new BracketStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'DROP':
            auto myBuilder = new DropStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'ALTER':
            auto myBuilder = new AlterStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        default:
            throw new UnsupportedFeatureException($k);
            break;
        }
        return this.created;
    }
}
