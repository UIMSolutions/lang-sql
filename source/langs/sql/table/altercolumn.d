module langs.sql.tables.altercolumn;

import langs.sql;

@safe:
class DSQLAlterColumn : DSQLUpdateStatement {
	this() {
		super();
	}

	this(string aTableName) {
		this();
		_tableName = aTableName;
	}

	this(string aTableName, string aColumnName) {
		this(aTableName);
		_columnName = aColumnName;
	}

	this(string aTableName, string aColumnName, string aColumnDefinition) {
		this(aTableName, aColumnName);
		_columnDefinition = aColumnDefinition;
	}

	mixin(TProperty!("string", "tableName"));
	mixin(TProperty!("string", "columnName"));
	mixin(TProperty!("string", "columnDefinition"));

	O column(this O)(string name, string definition) {
		_columnName = name;
		_columnDefinition = definition;
		return cast(O) this;
	}

	override string toSQL() {
		return "ALTER %s ALTER COLUMN %s %s".format(_tableName, _columnName, _columnDefinition);
	}
}

auto SQLAlterColumn() {
	return new DSQLAlterColumn;
}

auto SQLAlterColumn(string aTableName) {
	return new DSQLAlterColumn(aTableName);
}

auto SQLAlterColumn(string aTableName, string aColumnName) {
	return new DSQLAlterColumn(aTableName, aColumnName);
}

auto SQLAlterColumn(string aTableName, string aColumnName, string aColumnDefinition) {
	return new DSQLAlterColumn(aTableName, aColumnName, aColumnDefinition);
}

unittest {
	writeln("Testing ", __MODULE__);

	assert(SQLAlterColumn("xxx", "yyy", "zzz") == "ALTER xxx ALTER COLUMN yyy zzz");
	assert(SQLAlterColumn
			.tableName("xxx")
			.columnName("yyy")
			.columnDefinition("zzz") == "ALTER xxx ALTER COLUMN yyy zzz");
	assert(SQLAlterColumn
			.tableName("xxx")
			.column("yyy", "zzz") == "ALTER xxx ALTER COLUMN yyy zzz");
}
