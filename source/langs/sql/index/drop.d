module langs.sql.index.drop;

import langs.sql;

class DSQLDropIndex : DSQLUpdateStatement {
	this() { super(); }
	this(string indexName) { this(); _indexName = indexName; }
	this(string indexName, string tableName) { this(indexName); _tableName = tableName; }

	mixin(TProperty!("string", "indexName"));
	mixin(TProperty!("string", "tableName"));
	mixin(TProperty!("string", "vendor"));

	override string toSQL() {
		switch(vendor) {
			case "MSAccess": 
				return "DROP INDEX %s ON %s".format(_indexName, _tableName); 
			case "SQLServer": 
				return "DROP INDEX %s.%s".format(_tableName, _indexName); 
			case "MySQL": return "ALTER TABLE %s DROP INDEX %s".format(_tableName, _indexName); 
			default: return "DROP INDEX %s".format(_indexName); 
		}
	}
}
auto SQLDropIndex() { return new DSQLDropIndex(); }
auto SQLDropIndex(string indexName) { return new DSQLDropIndex(indexName); }
auto SQLDropIndex(string indexName, string tableName) { return new DSQLDropIndex(indexName, tableName); }

unittest {
	writeln ("Testing ", __MODULE__);
	
	assert(SQLDropIndex("xxx") == "DROP INDEX xxx");
}
