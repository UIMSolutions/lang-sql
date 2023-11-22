module langs.sql.sqlparsers.builders.create.tables.constraint;

import lang.sql;

@safe:

/**
 * Builds the constraint statement part of CREATE TABLE.
 * This class : the builder for the constraint statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ConstraintBuilder : ISqlBuilder {

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(CONSTRAINT) {
            return "";
        }
        string mySql = parsedSQL["sub_tree"] == false ? "" : this.buildConstant(parsedSQL["sub_tree"]);
        return "CONSTRAINT" ~ (mySql.isEmpty ? "" : (" " ~ mySql));
    }

}

