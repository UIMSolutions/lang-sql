module uim.sql.statements.update;

import uim.sql;

class DSQLUpdateStatement : DSQLStatement {
	this() {}
}
auto SQLUpdateStatement() { return new DSQLUpdateStatement; }

unittest {
	writeln("Testing ", __MODULE__);

	auto statement = SQLUpdateStatement;
}