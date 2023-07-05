module uim.sql.statements.query;

import uim.sql;

class DSQLQueryStatement : DSQLStatement {
	this() {}
}
auto SQLQueryStatement() { return new DSQLQueryStatement; }

