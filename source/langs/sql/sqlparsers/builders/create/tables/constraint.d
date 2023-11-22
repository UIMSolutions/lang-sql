module langs.sql.sqlparsers.builders.create.tables.constraint;

import lang.sql;

@safe:

/**
 * Builds the constraint statement part of CREATE TABLE.
 * This class : the builder for the constraint statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ConstraintBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    string build(Json parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(CONSTRAINT) {
            return "";
        }
        string mySql = $parsed["sub_tree"] == false ? "" : this.buildConstant($parsed["sub_tree"]);
        return "CONSTRAINT" ~ (mySql.isEmpty ? "" : (" " ~ mySql));
    }

}

