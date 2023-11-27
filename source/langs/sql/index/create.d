module langs.sql.index.create;

import langs.sql;
@safe:
class DSQLCreateIndex : DSQLUpdateStatement {
	this() { super(); }
	this(string indexName) { this(); _indexName = indexName; }
	this(string indexName, string tableName) { this(indexName); _tableName = tableName; }
	this(string indexName, string tableName, string columns) { this(indexName, tableName); _columns = columns; }

	mixin(TProperty!("string", "indexName"));
	mixin(TProperty!("string", "tableName"));
	mixin(TProperty!("string", "columns"));

	bool _unique;
	O unique(this O)() { 
		_unique = true; 
		return cast(O)this;
	} 

	override string toSQL() {
		if (_unique) return "CREATE UNIQUE INDEX %s ON %s (%s)".format(_indexName, _tableName, _columns); 
		return "CREATE INDEX %s ON %s (%s)".format(_indexName, _tableName, _columns); 
	}
}
auto SQLCreateIndex() { return new DSQLCreateIndex(); }
auto SQLCreateIndex(string indexName) { return new DSQLCreateIndex(indexName); }
auto SQLCreateIndex(string indexName, string tableName) { return new DSQLCreateIndex(indexName, tableName); }
auto SQLCreateIndex(string indexName, string tableName, string columns) { return new DSQLCreateIndex(indexName, tableName, columns); }

unittest {
	writeln ("Testing ", __MODULE__);

	assert(SQLCreateIndex("xxx", "yyy", "zzz") == "CREATE INDEX xxx ON yyy (zzz)");
	assert(SQLCreateIndex("xxx", "yyy", "zzz").unique == "CREATE UNIQUE INDEX xxx ON yyy (zzz)");
}
