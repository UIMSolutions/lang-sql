module langs.sql.sqlparsers.builders.index.algorithm;

import lang.sql;

@safe:

/**
 * Builds index algorithm part of a CREATE INDEX statement.
 * This class : the builder for the index algorithm of CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class IndexAlgorithmBuilder : ISqlBuilder {

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildOperator(parsedSQL) {
        auto myBuilder = new OperatorBuilder();
        return myBuilderr.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(INDEX_ALGORITHM) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildOperator(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE INDEX algorithm subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
