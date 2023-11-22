module langs.sql.sqlparsers.builders.create.tables.constraint;

import lang.sql;

@safe:

/**
 * Builds the constraint statement part of CREATE TABLE.
 * This class : the builder for the constraint statement part of CREATE TABLE. 
 *  */
class ConstraintBuilder : ISqlBuilder {

    protected auto buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(CONSTRAINT) {
            return "";
        }
        string mySql = parsedSql["sub_tree"] == false ? "" : this.buildConstant(parsedSql["sub_tree"]);
        return "CONSTRAINT" ~ (mySql.isEmpty ? "" : (" " ~ mySql));
    }

}

