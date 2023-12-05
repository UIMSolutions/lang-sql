module langs.sql.sqlparsers.builders.replacecolumnlist;
import lang.sql;

@safe:

/*alias Alias = ;*/

// Builds column-list parts of REPLACE statements. 
class ReplaceColumnListBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("COLUMN_LIST")) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
           mySql ~= this.buildColumn(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("REPLACE column-list subtree", myKey, myValue, "expr_type");
            }

           mySql ~= ", ";
        }
        return "(" ~ substr(mySql, 0, -2) ~ ")";
    }

    protected string buildColumn(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }
}
