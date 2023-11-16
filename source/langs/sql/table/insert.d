module langs.sql.tables.insert;

import langs.sql;

class DSQLInsert : DSQLStatement {
    
	this() { }
	this(string table, string[string] values = null) { this(); from(table).values(values); }
	this(string table = "", string names = "", string values = "") { this(); from(table).values(names, values); }

	protected string _table;
	auto from(string name) { return table(name); }
	auto table(string name) {
		if (name.length > 0) _table = name;
		return this;
	} 

	protected string _columns;
	protected string _values;
	auto columns(string names) { 
		_columns = names;
		return this;
	}
	auto values(string values) { 
		_values = values;
		return this;
	}

	auto values(string[string] vals) {  
		auto keys = vals.keys;
		string[] v = new string[keys.length];
		foreach(i, key; keys) v[i] = vals[key];
		
		values(keys.join(","), v.join(","));        
		return this;
	}
	auto values(string names, string values) { 
		_columns = names;
		_values = values;
		return this;
	}

    override string toSQL() {
		auto sql = "INSERT INTO " ~_table~" (" ~_columns~") VALUES(" ~_values~")";        
		return sql;
	}
}
auto SQLInsert() { return new DSQLInsert; }
auto SQLInsert(string table, string[string] values) { return new DSQLInsert(table, values); }
auto SQLInsert(string table = "", string names = "", string values = "") { return new DSQLInsert(table, names, values); }

unittest {
	writeln("Testing ", __MODULE__);

	assert(SQLInsert.table("tab").columns("id, name").values("1, 'test1'") == "INSERT INTO tab (id, name) VALUES(1, 'test1')");
}
