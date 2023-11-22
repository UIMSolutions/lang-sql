
module langs.sql.sqlparsers.builders.setexpression;

import lang.sql;

@safe:

/**
 * Builds the SET part of the INSERT statement. */
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
class SetExpressionBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildOperator(parsedSQL) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildSign(parsedSQL) {
        auto myBuilder = new SignBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(EXPRESSION) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
            string myDelim = " ";
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildBracketExpression(myValue);
                        
            // we don"t need whitespace between the sign and 
            // the following part
            if (this.buildSign(myValue) != "") {
                myDelim = "";
            }
            mySql ~= this.buildSign(myValue);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("SET expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= myDelim;
        }
        mySql = substr(mySql, 0, -1);
        return mySql;
    }
}
