module langs.sql.PHPSQLParser.processors.create;

import lang.sql;

@safe:

/**
 * This file : the processor for the CREATE statements.
 * This class processes the CREATE statements.
 */
class CreateProcessor : AbstractProcessor {

    auto process($tokens) {
        $result = myExpression = [];
        baseExpression = "";

        foreach (myToken; $tokens) {
            
            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case 'TEMPORARY':
                // CREATE TEMPORARY TABLE
                $result["expr_type"] .isExpressionType(TEMPORARY_TABLE;
                $result["not-exists"] = false;
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;

            case 'TABLE':
                // CREATE TABLE
                $result["expr_type"] =  expressionType("TABLE");
                $result["not-exists"] = false;
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;

            case 'INDEX':
                // CREATE INDEX
                $result["expr_type"] .isExpressionType(INDEX;
                myExpression[] = ["expr_type" : expressionType("RESERVED", "base_expr" : strippedToken);
                break;

            case 'UNIQUE':
            case 'FULLTEXT':
            case 'SPATIAL':
                // options of CREATE INDEX
                $result["base_expr"] = $result["expr_type"] = false;
                $result["constraint"] = upperToken; 
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;                
                                
            case 'IF':
                // option of CREATE TABLE
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;

            case 'NOT':
                // option of CREATE TABLE
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;

            case 'EXISTS':
                // option of CREATE TABLE
                $result["not-exists"] = true;
                myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                break;

            default:
                break;
            }
        }
        $result["base_expr"] = baseExpression.strip;
        $result["sub_tree"] = myExpression;
        return $result;
    }
}