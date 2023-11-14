module source.langs.sql.PHPSQLParser.builders.insert.columnlist;

import lang.sql;

@safe:

/**
 * Builds column-list parts of INSERT statements.
 * This class : the builder for column-list parts of INSERT statements. 
 * You can overwrite all functions to achieve another handling. */
class InsertColumnListBuilder : ISqlBuilder {

    protected auto buildColumn($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) { return ""; }

        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColumn(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('INSERT column-list subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= ", ";
        } 
        
        return "(" . substr(mySql, 0, -2) . ")";
    }

}
