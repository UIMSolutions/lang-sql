module langs.sql.sqlparsers.builders.create.tables.foreignref;

import langs.sql;

@safe:

// Builds the FOREIGN KEY REFERENCES statement part of CREATE TABLE. */
class ForeignRefBuilder : ISqlBuilder {

    protected string buildTable(Json parsedSql) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, 0);
    }

    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("REFERENCE")) {
            return "";
        }
        string mySql = parsedSql["sub_tree"].byKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        return substr(mySql, 0, -1);
    }

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;

        result ~= this.buildTable(aValue);
        result ~= this.buildReserved(aValue);
        result ~= this.buildColumnList(aValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("CREATE TABLE foreign ref subtree", aKey, aValue, "expr_type");
        }

        result ~= " ";
        return result;
    }
}

unittest {
  auto builder = new ForeignRefBuilder;
  assert(builder, "Could not create ForeignRefBuilder");
}