module uim.sql.tables.altertable;

import uim.sql;

string sqlAlterTable(string tableName) { return "ALTER "~tableName; }
string sqlAddColumn(string columnName, string definition) { return "ADD "~columnName~" "~definition; }
string sqlAddColumn(string sql, string columnName, string definition) { return sql~" "~sqlAddColumn(columnName, definition); }

class DSQLAlterTable : DSQLUpdateStatement {
	this() { super(); }
	this(string aTableName) { this(); _tableName = aTableName; }
	mixin(OProperty!("string", "tableName")); 

	alias this toString;

	override string toSQL() {
		return "ALTER %s".format(_tableName); // ADD %s %s".format(_tableName, _columnName, _columnDefinition);
	}
}
auto SQLAlterTable() { return new DSQLAlterTable(); }
auto SQLAlterTable(string aTableName) { return new DSQLAlterTable(aTableName); }

unittest {
	writeln("Testing ", __MODULE__);

	assert(sqlAlterTable("aTable") == "ALTER aTable");
	assert(sqlAddColumn("xxx", "yyy") == "ADD xxx yyy");
	assert(sqlAlterTable("aTable").sqlAddColumn("xxx", "yyy") == "ALTER aTable ADD xxx yyy");

	assert(SQLAlterTable("aTable") == "ALTER aTable");
}