module langs.sql.tables.update;

import langs.sql;

class DSQLUpdate : DSQLUpdateStatement  {
	protected string _table;
     
	this() { super(); }
	this(string tableName) { this(); table(tableName); }
	this(string tableName, string[string] values, string condition = "") { this(tableName); sets(values).where(condition); }
	this(string tableName, string value = "", string condition = "") { this(tableName); sets(value).where(condition); }
	this(string tableName, string[string] values, string[] conditions) { this(tableName); sets(values).where(conditions); }
	this(string tableName, string value, string[] conditions) { this(tableName); sets(value).where(conditions); }

	auto table(string name) {
		if (name.length > 0) _table = name;
		return this;
	} 

	protected string _sets;
	auto sets(string[string] values) { 
		string[] s;
		foreach(k, v; values) s ~= k~"="~v;
		return sets(s);
	}
	auto sets(string[] values...) { 
		return sets(values);
	}
	auto sets(string[] values) { 
		_sets = values.join(","); 
		return this;
	}

	protected string _where;
	auto where(string[] conditions...) {
		return where(conditions);
	} 
	auto where(string[] conditions = null) {
		if (conditions.length > 0) _where = conditions.join(" AND ");
		return this;
	} 

  override string toSQL() {
		auto sql = "UPDATE "~_table~" SET "~_sets;
		if (_where.length > 0) sql ~= " WHERE "~_where;
		return sql;
	}

}
auto SQLUpdate() { return new DSQLUpdate(); }
auto SQLUpdate(string table) { return new DSQLUpdate(table); }
auto SQLUpdate(string table, string values, string condition = "") { return new DSQLUpdate(table, values, condition); }
auto SQLUpdate(string table, string values, string[] conditions) { return new DSQLUpdate(table, values, conditions); }
auto SQLUpdate(string table, string[string] values, string condition = "") { return new DSQLUpdate(table, values, condition); }
auto SQLUpdate(string table, string[string] values, string[] conditions) { return new DSQLUpdate(table, values, conditions); }

unittest {
	writeln("Testing ", __MODULE__);
	
	assert(SQLUpdate("tab", "x = 1") == "UPDATE tab SET x = 1"); 
	assert(SQLUpdate.table("tab").sets("x = 1") == "UPDATE tab SET x = 1"); 
	assert(SQLUpdate.table("tab").sets("x = 1", "y = 2") == "UPDATE tab SET x = 1,y = 2"); 
	assert(SQLUpdate.table("tab").sets(["x = 1", "y = 2"]) == "UPDATE tab SET x = 1,y = 2"); 

	assert(SQLUpdate("tab", "x = 1", "a > b") == "UPDATE tab SET x = 1 WHERE a > b"); 
	assert(SQLUpdate.table("tab").sets("x = 1").where("a > b") == "UPDATE tab SET x = 1 WHERE a > b"); 
	assert(SQLUpdate.table("tab").sets("x = 1", "y = 2").where("a > b") == "UPDATE tab SET x = 1,y = 2 WHERE a > b"); 
	assert(SQLUpdate.table("tab").sets(["x = 1", "y = 2"]).where("a > b") == "UPDATE tab SET x = 1,y = 2 WHERE a > b"); 

	assert(SQLUpdate("tab", "x = 1", ["(a > b)", "(c < d)"]) == "UPDATE tab SET x = 1 WHERE (a > b) AND (c < d)"); 
	assert(SQLUpdate.table("tab").sets("x = 1").where(["(a > b)", "(c < d)"]) == "UPDATE tab SET x = 1 WHERE (a > b) AND (c < d)"); 
	assert(SQLUpdate.table("tab").sets("x = 1", "y = 2").where(["(a > b)", "(c < d)"]) == "UPDATE tab SET x = 1,y = 2 WHERE (a > b) AND (c < d)"); 
	assert(SQLUpdate.table("tab").sets(["x = 1", "y = 2"]).where(["(a > b)", "(c < d)"]) == "UPDATE tab SET x = 1,y = 2 WHERE (a > b) AND (c < d)"); 
}
