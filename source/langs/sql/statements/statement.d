module langs.sql.statements.statement;

import langs.sql;

@safe:
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
