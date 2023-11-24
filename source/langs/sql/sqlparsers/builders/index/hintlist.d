module langs.sql.sqlparsers.builders.index.IndexHintListBuilder;

// Builds the index hint list of a table.
class IndexHintListBuilder : ISqlBuilder {

    auto hasHint(Json parsedSql) {
        return isset(parsedSql["hints"]);
    }

    // TODO: the hint list should be enhanced to get base_expr fro position calculation
    string build(Json parsedSql) {
        if (!isset(parsedSql["hints"]) || parsedSql["hints"] == false) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["hints"]) {
            mySql ~= myValue["hint_type"] ~ " " ~ myValue["hint_list"] ~ " ";
        }
        return " " ~ substr(mySql, 0, -1);
    }
}
