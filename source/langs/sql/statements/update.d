module langs.sql.statements.update;

import langs.sql;
@safe:
class DSQLUpdateStatement : DSQLStatement {
	this() {}
}
auto SQLUpdateStatement() { return new DSQLUpdateStatement; }

unittest {
	writeln("Testing ", __MODULE__);

	auto statement = SQLUpdateStatement;
}