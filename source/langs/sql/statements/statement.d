module uim.sql.statements.statement;

import uim.sql;

class DSQLStatement {
	this() {}

	override bool opEquals(Object value) {
		return super.opEquals(value);
	}
	bool opEquals(string value) {
		return toString == value;
	}

	string toSQL() { return ""; }
	override string toString() { return toSQL; }
}
auto SQLStatement() { return new DSQLStatement; }
