module langs.sql.functions.alter;

import langs.sql;
@safe:
class DSQLAlterFunction : DSQLStatement {
	this() {}
	this(string functionName) { this(); _functionName = functionName; } 
	this(string functionName, string content) { this(functionName); _content = content; } 

	mixin(TProperty!("string", "functionName"));
	mixin(TProperty!("string", "content"));

	override string toSQL() {
		return "ALTER FUNCTION %s %s".format(_functionName, _content);
	}
}
auto SQLAlterFunction() { return new DSQLAlterFunction; }
auto SQLAlterFunction(string functionName) { return new DSQLAlterFunction(functionName); } 
auto SQLAlterFunction(string functionName, string content) { return new DSQLAlterFunction(functionName, content); } 

