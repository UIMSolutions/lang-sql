module langs.sql.statements.query;

import langs.sql;

@safe:
class DSQLQueryStatement : DSQLStatement {
	this() {}
}
auto SQLQueryStatement() { return new DSQLQueryStatement; }

