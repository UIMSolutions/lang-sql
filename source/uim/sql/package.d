module uim.sql;

public import std.algorithm;
public import std.conv;
public import std.stdio;
public import std.string;

public import uim.core;
public import uim.sql.statements;
public import uim.sql.tables;
public import uim.sql.index;
public import uim.sql.functions;

string OR(string[] conditions) {
	string[] c = new string[conditions.length];
	foreach(i, x; conditions) c[i] = "("~x~")";
	if (conditions.length > 0) return c.join(" OR ");
	return "";
} 
string AND(string[] conditions) {
	string[] c = new string[conditions.length];
	foreach(i, x; conditions) c[i] = "("~x~")";
	if (conditions.length > 0) return c.join(" AND ");
	return "";
} 

alias STRINGAA = string[string];

//auto tableNames(Database db) {
//	string[] names;
//	foreach (row; db.execute("SELECT name FROM sqlite_master WHERE (type='table')")) {
//		auto name = row[0].as!string.toUpper;
//		if (name == "SQLITE_STAT1") continue;
//		
//		names ~= name;
//	}
//	return names;
//}
//string[] readTableColumns(Database db) {
//	string[][string] results;
//	foreach(tableName; tableNames(db)) {
//		if (tableName == "STOCKS") continue;
//		results[tableName] ~= readTableColumns(db, tableName);
//	}
//	return uniqueColumns(results);
//}
//string[] uniqueColumns(string[][string] colinTableNames) {
//	string[string] results;
//	foreach(tName, cols; colinTableNames) 
//		foreach(col; cols) results[col] = tName;
//	return results.keys;
//}
//string[] readTableColumns(Database db, string tableName) {
//	foreach (row; QueryCache(db.execute("SELECT * FROM "~tableName~" LIMIT 1"))) return row.columnIndexes.keys;
//	return null;
//}

/++
 readRow - Reading data from a SQL result 
 +/
void readFromDB(T)(DataRow!T dataRow, QueryCache.CachedRow dbRow, size_t[string] colName2Index, size_t[string] ignoreFlds = null) {
	if (dataRow) {
		if (ignoreFlds) {
			foreach(k, v; dbRow.columnIndexes) {
				auto kk = k.toUpper;
				if (!(kk in ignoreFlds)) dataRow[colName2Index[kk]] = dbRow[v].as!T;
			}
		}
		else {
			foreach(k, v; dbRow.columnIndexes) { 
				dataRow[colName2Index[k.toUpper]] = dbRow[v].as!T;
			}
		}
	}
}

void readFromDB(T)(DataMatrix!T matrix, size_t pos, QueryCache.CachedRow dbRow, size_t[string] colName2Index, size_t[string] ignoreFlds = null) {
	if (!matrix) return;
	
	if (auto row = matrix[pos]) {
		if (ignoreFlds) {
			foreach(k, v; dbRow.columnIndexes) {
				auto kk = k.toUpper;
				if (!(kk in ignoreFlds)) row[colName2Index[kk]] = dbRow[v].as!T;
			}
		}
		else {
			foreach(k, v; dbRow.columnIndexes) { 
				auto kk = k.toUpper;
				row[colName2Index[kk]] = dbRow[v].as!T;
			}
		}
	}
}

void readFromDB(T)(DataSplice!T splice, size_t pos, QueryCache.CachedRow dbRow, size_t[string] colName2Index, size_t[string] ignoreFlds = null) {
	if ((splice) && (pos < splice.height)) {
		if (ignoreFlds) {
			foreach(k, v; dbRow.columnIndexes) {
				auto kk = k.toUpper;
				if (!(kk in ignoreFlds)) splice[pos, colName2Index[kk]] = dbRow[v].as!T;
			}
		}
		else {
			foreach(k, v; dbRow.columnIndexes) { 
				auto kk = k.toUpper;
				splice[pos, colName2Index[kk]] = dbRow[v].as!T;
			}
		}
	}
}

void save(T)(Database db, DataTable!T rows, string[] sources, string company) {
	writeln("--- void save(Database db, DRow[] rows, string[] sources)...");
	
	auto pre = "(IDAY = %s) AND (NAME = '"~company~"')";	
	foreach(iday, row; rows) if (row) {				
		auto sel = pre.format(iday);
		auto update = "";
		foreach(source; sources) {
			if (auto cells = row.changedCells(source)) {
				update ~= "UPDATE "~source.sets(cells).where(sel)~";";		
			}
		}
		try {
			db.execute(update);
		}
		catch(Exception e) {
			foreach(source; sources) {
				if (auto cells = row.changedCells(source)) {
					db.run("UPDATE "~source.sets(cells).where(sel));		
				}
			}
		}
	}
}

void save(T)(Database db, DataRow!(T)[] rows, string[] tableNames) {
	// writeln("--- void save(Database db, DRow[] rows, string[] sources)...");
	
	auto pre = "(IDAY = %s) AND (NAME = '%s')";	
	foreach(row; rows) if (row) {	
		auto name = row["NAME"].value!string;
		auto iday = row["IDAY"].value!int;
		auto sel = pre.format(iday, name);
		
		auto update = "";
		foreach(tableName; tableNames) {
			if (auto cells = row.changedCells(tableName)) {
				update ~= "UPDATE "~tableName.sets(cells).where(sel)~";";		
			}
		}
		try {
			debug writeln(update);
			db.run(update);
		}
		catch(Exception e) {
			writeln(e);
			foreach(tableName; tableNames) {
				if (auto cells = row.changedCells(tableName)) {
					db.run("UPDATE "~tableName.sets(cells).where(sel));		
				}
			}
		}
	}
}
//string[] columns(Database db, string tableName, string[] ignoreNames = null) {
//	string[] names;
//	foreach(row; db.execute("PRAGMA table_info("~tableName~")")) {
//		auto name = row[1].as!string.toUpper;
//		if(name.isIn(ignoreNames)) continue;
//		
//		names ~= name;
//	}
//	return names;
//}
//
//void save(T)(Database db, T[size_t][] changedCellsInRows, string[][string] tableCells, string companyName, size_t start = 0, bool dMode = false) {
//	writeln("--- void save(Database db, DRow[] rows, string[] sources)...");
//	
//	auto pre = "(NAME = '"~companyName~"') AND (IDAY = %s)";	
//	foreach(iday, row; changedCellsInRows) if (row) {	
//		if (iday < start) continue; 
//		auto where = pre.format(iday);
//		
//		auto update = "";
//		foreach(tName, table; tableCells) {
//			string[] sets;
//			foreach(cell; table) if (cell in row) sets ~= "%s=%s".format(cell, row[cell]);
//			if (sets) update ~= "UPDATE %s SET %s WHERE %s;".format(tName, sets.join(","), where);		
//		}
//		try { 
//			//writeln(update);
//			db.run(update); }
//		catch(Exception e) { writeln(e); }
//	}
//}

string sqlDeleteFrom(string tableName, string where = null) {
	if (where) return "DELETE FROM %s WHERE %s;".format(tableName, where); 
	return "DELETE FROM %s;".format(tableName);
}
//void deleteFrom(Database db, string tableName, string where = null) {
//	try { db.run(sqlDeleteFrom(tableName, where)); } 
//	catch(Exception e) { writeln("ERROR ", e); }
//}
//
//string sqlInsertInto(string tableName, string[] valueNames, string[] values) { 
//	return sqlInsertInto(tableName, valueNames.join(","), values.join(",")); }
//string sqlInsertInto(string tableName, string valueNames, string values) {
//	return "INSERT INTO %s (%s) VALUES(%s);".format(tableName, valueNames, values); }
//
//void insertInto(Database db, string tableName, string[] valueNames, string[] values) { 
//	insertInto(db, tableName, valueNames.join(","), values.join(",")); }
//void insertInto(Database db, string tableName, string valueNames, string values) {
//	try { db.run(sqlInsertInto(tableName, valueNames, values)); } 
//	catch(Exception e) { writeln("ERROR ", e); }
//}
//void insertInto(Database db, string sql) {
//	try { db.run(sql); } 
//	catch(Exception e) { writeln("ERROR ", e); }
//}
//bool exists(Database db, string sql) {
//	foreach(data; db.execute(sql)) return true;
//	return false;
//}

string[] quote(string[] source, string quoteString) { return quote(source, quoteString, quoteString); }
string[] quote(string[] source, string start, string end) {
	string[] result;
	foreach(s; source) result ~= start~s~end;
	return result;
}

//void update(Database db, string tableName, string[] sets, string where = null) { update(db, tableName, sets.join(","), where); }
//void update(Database db, string tableName, string sets, string[] where) {
//	try { db.run(sqlUpdate(tableName, sets, where)); } 
//	catch(Exception e) { writeln("ERROR ", e); }
//}
//void update(Database db, string tableName, string sets, string where = null) {
//	try { db.run(sqlUpdate(tableName, sets, where)); } 
//	catch(Exception e) { writeln("ERROR ", e); }
//}
//
//auto readTradesLevel0(Database db, string where = "") {
//	STRINGAA tradeStrategies;
//	auto select = "SELECT ID, L0 FROM TRADES WHERE (LEVEL = 0)"~(where.length > 0 ? " AND "~where : "");
//	foreach(row; db.execute(select)) {
//		auto id = row[0].as!string;
//		auto level0 = row[1].as!string;
//		tradeStrategies[level0] = id;
//	}
//	return tradeStrategies;
//}

//auto readTradesLevel1(Database db, string where = "") {
//	STRINGAA[string] tradeStrategies;
//	auto select = "SELECT ID, L0, L1 FROM TRADES WHERE (LEVEL = 1)"~(where.length > 0 ? " AND "~where : "");
//	foreach(row; db.execute(select)) {
//		auto id = row[0].as!string;
//		auto level0 = row[1].as!string;
//		auto level1 = row[2].as!string;
//		if (level0 !in tradeStrategies) {
//			STRINGAA values; 
//			tradeStrategies[level0] = values;
//		}
//		tradeStrategies[level0][level1] = id;
//	}
//	return tradeStrategies;
//}
//
//auto readTradesLevel2(Database db, string where = "") {
//	STRINGAA[string][string] tradeStrategies;
//	auto select = "SELECT ID, L0, L1, L2 FROM TRADES WHERE (LEVEL = 2)"~(where.length > 0 ? " AND "~where : "");
//	foreach(row; db.execute(select)) {
//		auto id = row[0].as!string;
//		auto level0 = row[1].as!string;
//		auto level1 = row[2].as!string;
//		auto level2 = row[3].as!string;
//		if (level0 !in tradeStrategies) {
//			STRINGAA[string] values;
//			tradeStrategies[level0] = values;
//		}
//		if (level1 !in tradeStrategies[level0]) {
//			STRINGAA values;
//			tradeStrategies[level0][level1] = values;
//		}
//		tradeStrategies[level0][level1][level2] = id;
//	}
//	return tradeStrategies;
//}
//auto readTradesLevel3(Database db, string where = "") {
//	STRINGAA[string][string][string] tradeStrategies;
//	auto select = "SELECT ID, L0, L1, L2, L3 FROM TRADES WHERE (LEVEL = 3)"~(where.length > 0 ? " AND "~where : "");
//	foreach(row; db.execute(select)) {
//		auto id = row[0].as!string;
//		auto level0 = row[1].as!string;
//		auto level1 = row[2].as!string;
//		auto level2 = row[3].as!string;
//		auto level3 = row[4].as!string;
//		if (level0 !in tradeStrategies) {
//			STRINGAA[string][string] values;
//			tradeStrategies[level0] = values;
//		}
//		if (level1 !in tradeStrategies[level0]) {
//			STRINGAA[string] values;
//			tradeStrategies[level0][level1] = values;
//		}
//		if (level2 !in tradeStrategies[level0][level1]) {
//			STRINGAA values;
//			tradeStrategies[level0][level1][level2] = values;
//		}
//		tradeStrategies[level0][level1][level2][level3] = id;
//	}
//	return tradeStrategies;
//}

string deleteStrategy(string strategy) {
	return sqlDeleteFrom("trades", "(ID = '%')".format(strategy));
}

//string[] colNames(Database db, string[] exclusiveCols = []) { return colNames(db, db.tableNames, exclusiveCols); }
//string[] colNames(Database db, string[] tableNames, string[] exclusiveCols) {
//	string[] result;
//	
//	foreach(tableName; tableNames) {
//		auto cols = db.columns(tableName, exclusiveCols~result);
//		result ~= cols;
//	}
//	
//	return result;
//}

//string[][string] colNamesOfTables(Database db, string[] exclusiveCols) { return colNamesOfTables(db, db.tableNames, exclusiveCols); }
//string[][string] colNamesOfTables(Database db, string[] tableNames, string[] exclusiveCols) {
//	string[][string] result;
//	string[] allColumns;
//	
//	foreach(tableName; tableNames) {
//		auto cols = db.columns(tableName, exclusiveCols~allColumns);
//		allColumns ~= cols;
//		result[tableName] = cols;
//	}
//	
//	return result;
//}
//
//enum TABLEINITHEIGHT = 7000;
//
//string[] readCompanies(Database db, string select = "(ID > '%')") {
//	string[] result;
//	foreach (row; QueryCache(db.execute("SELECT ID FROM COMPANIES WHERE %s ORDER BY ID".format(select)))) 
//		result ~= row[0].as!string;
//	return result;
//}
//
//string[] readGens(Database db, string select = "(NAME > '%')") {
//	string[] result;
//	foreach(row; db.execute("SELECT NAME FROM GENS")) result ~= row[0].as!string;
//	return result;
//}
//
//T count(T:size_t)(Database db, string table, string where) {
//	return SQLSelect("count(*)", table).where(where)(db).oneValue!T;
//}
