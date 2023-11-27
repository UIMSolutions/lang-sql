module langs.sql.functions.select;

import langs.sql;
@safe:
class DSQLSelectFunction : DSQLStatement {
	this() {}
	this(string functionName) { this(); } 
	this(string functionName, string values) { this(functionName); _values = values; } 

	mixin(TProperty!("string", "name"));
	mixin(TProperty!("string", "values"));

	override string toSQL() {
		return "SELECT %s(%s)".format(_name, _values);
	}
}
auto SQLSelectFunction() { return new DSQLSelectFunction; }
auto SQLSelectFunction(string functionName) { return new DSQLSelectFunction(functionName); } 
auto SQLSelectFunction(string functionName, string values) { return new DSQLSelectFunction(functionName, values); } 

