module langs.sql.tables.select;

import langs.sql;

string sqlSelectFromTable(string tableName, string attributes = "*") { return "SELECT "~attributes~" FROM "~tableName; }
string sqlWhere(string condition) { return "WHERE "~condition; }
string sqlLimit(string limit) { return "LIMIT "~limit; }
string sqlLimit(size_t limit) { return "LIMIT "~to!string(limit); }

class DSQLSelect : DSQLQueryStatement {
	protected string _columns;
	protected string _table;
	protected string _where;
	protected string _orderBy;
	protected string _groupBy;
	protected size_t _limit;
	protected size_t _offset;

	this() { } 
	this(string attributes, string from = "", string condition = "") { this(); columns(attributes).table(from).where(condition); } 
	this(string[] attributes, string from = "", string condition = "") { this(); columns(attributes).table(from).where(condition); }

    auto clear() { 
		_columns = null;
		_table = null;
		_where = null;
		_orderBy = null;
		_groupBy = null;
		_limit = 0;
		_offset = 0;
		return this;
	}
	auto columns(string[] attributes...) {
		return columns(attributes);
	} 
	auto columns(string[] attributes) {
		_columns = attributes.join(",");
		if (_columns.length == 0) _columns = "*";
		writeln("Columns = ", _columns);

		return this;
	} 
	auto table(string table) {
		if (table.length > 0) _table = table;
		return this;
	} 
	auto where(string condition = null) {
		if (condition.length > 0) _where = condition;
		return this;
	} 
	auto where(string[] conditions) {
		if (conditions.length > 0) _where = AND(conditions);
		return this;
	} 
	auto orderBy(string columns = null) {
		if (columns.length > 0) _orderBy = columns;
		return this;
	} 
	auto orderBy(string[] columns) {
		if (columns.length > 0) _orderBy = columns.join(",");
		return this;
	} 
	auto groupBy(string columns = null) {
		if (columns.length > 0) _groupBy = columns;
		return this;
	} 
	auto groupBy(string[] columns) {
		if (columns.length > 0) _groupBy = columns.join(",");
		return this;
	} 
	auto limit(size_t value) {
		if (value > 0) _limit = value;
		return this;
	} 
	auto offset(size_t value) {
		if (value > 0) _offset = value;
		return this;
	} 
	// auto opCall(Database db) {
		// auto sql = toSQL;
		// writeln(sql);
		// return db.execute(sql);
	// }

	override string toSQL() {
		if (_columns.length == 0) _columns = "*";
		string sql = "SELECT "~_columns~" FROM "~_table;
		if (_where.length > 0) sql ~= " WHERE "~_where;
		if (_orderBy.length > 0) sql ~= " ORDER BY "~_orderBy;
		if (_groupBy.length > 0) sql ~= " GROUP BY "~_groupBy;
		if (_limit > 0) sql ~= " LIMIT %s".format(_limit);
		if (_offset > 0) sql ~= " OFFSET %s".format(_offset);
		return sql;
	}
}
auto SQLSelect() { return new DSQLSelect(); } 
auto SQLSelect(string attributes, string from = "", string where = "") { return new DSQLSelect(attributes, from, where); } 
auto SQLSelect(string[] attributes, string from = "", string where = "") { return new DSQLSelect(attributes, from, where); } 

unittest {
	writeln("Testing ", __MODULE__);

	assert(sqlSelectFromTable("aTable") == "SELECT * FROM aTable");
	assert(sqlSelectFromTable("aTable", "a, b") == "SELECT a, b FROM aTable");

	assert(SQLSelect.table("table") == "SELECT * FROM table");

	assert(SQLSelect.table("table").columns("xxx") == "SELECT xxx FROM table");
	assert(SQLSelect.table("table").columns("") == "SELECT * FROM table");
	assert(SQLSelect.table("table").columns("*") == "SELECT * FROM table");
}
