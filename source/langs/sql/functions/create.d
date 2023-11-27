module langs.sql.functions.create_;

import langs.sql;
@safe:
class DSQLCreateFunction : DSQLStatement {
	this() {}
	this(string functionName) { this(); _functionName = functionName; } 
	this(string functionName, string parameters) { this(functionName); _parameters = parameters; } 
	this(string functionName, string parameters, string returnType) { this(functionName, parameters); _returnType = returnType; } 
	this(string functionName, string parameters, string returnType, string content) { this(functionName, parameters, returnType); _content = content; } 

	mixin(TProperty!("string", "functionName"));
	mixin(TProperty!("string", "parameters"));
	mixin(TProperty!("string", "returnType"));
	mixin(TProperty!("string", "content"));
	mixin(TProperty!("string", "language"));

	override string toSQL() {
		auto lang = "SQL";
		if (_language) lang = _language;
		return "CREATE FUNCTION %s(%s) RETURNS %s AS $$ %s $$ LANGUAGE %s;".format(_functionName, _parameters, _returnType, _content, lang);
	}
}
auto SQLCreateFunction() { return new DSQLCreateFunction; }
auto SQLCreateFunction(string functionName) { return new DSQLCreateFunction(functionName); } 
auto SQLCreateFunction(string functionName, string parameters) { return new DSQLCreateFunction(functionName, parameters); } 
auto SQLCreateFunction(string functionName, string parameters, string returnType) { return new DSQLCreateFunction(functionName, parameters, returnType); } 
auto SQLCreateFunction(string functionName, string parameters, string returnType, string content) { return new DSQLCreateFunction(functionName, parameters, returnType, content); } 

