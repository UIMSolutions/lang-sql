module langs.sql.sqlparsers.builders.tablebracketexpression;

import lang.sql;

@safe:

// Builds the table expressions within the create definitions of CREATE TABLE. 
class TableBracketExpressionBuilder : ISqlBuilder {

    protected string buildColDef(Json parsedSql) {
        auto myBuilder = new ColumnDefinitionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildPrimaryKey(Json parsedSql) {
        auto myBuilder = new PrimaryKeyBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildForeignKey(Json parsedSql) {
        auto myBuilder = new ForeignKeyBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildCheck(Json parsedSql) {
        auto myBuilder = new CheckBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildLikeExpression(Json parsedSql) {
        auto myBuilder = new LikeExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexKey(Json parsedSql) {
        auto myBuilder = new IndexKeyBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildUniqueIndex(Json parsedSql) {
        auto myBuilder = new UniqueIndexBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFulltextIndex(Json parsedSql) {
        auto myBuilder = new FulltextIndexBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
            return "";
        }
        string mySql = parsedSql["sub_tree"].byKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        mySql = " (" ~ substr(mySql, 0, -2) ~ ")";
        return mySql;
    }

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;

        result ~= this.buildColDef(aValue);
        result ~= this.buildPrimaryKey(aValue);
        result ~= this.buildCheck(aValue);
        result ~= this.buildLikeExpression(aValue);
        result ~= this.buildForeignKey(aValue);
        result ~= this.buildIndexKey(aValue);
        result ~= this.buildUniqueIndex(aValue);
        result ~= this.buildFulltextIndex(aValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("CREATE TABLE create-def expression subtree", aKey, aValue, "expr_type");
        }

        result ~= ", ";
        return result;
    }
}
