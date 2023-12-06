module langs.sql.sqlparsers.processors.indexcolumnist;

import lang.sql;

@safe:
// Processor for index column lists.
class IndexColumnListProcessor : Processor {
    protected auto initExpression() {
        return ["name" : false, "no_quotes" : false, "length" : false, "dir" : false];
    }

    Json process(mysql) {
        mytokens = this.splitSQLIntoTokens(mysql);

       myExpression = this.initExpression();
        myresult = [];
        baseExpression = "";

        foreach (mytokens as myk : mytoken) {

            auto strippedToken = mytoken.strip;
            baseExpression ~= mytoken;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case "ASC":
            case "DESC":
            # the optional order
               myExpression["dir"] = strippedToken;
                break;

            case ",":
            # the next column
                myresult ~= array_merge(createExpression(INDEX_COLUMN, "base_expr" : baseExpression),
                       myExpression);
               myExpression = this.initExpression();
                baseExpression = "";
                break;

            default:
                if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                    # the optional length
                   myExpression["length"] = this.removeParenthesisFromStart(strippedToken);
                    continue 2;
                }
                # the col name
               myExpression["name"] = strippedToken;
               myExpression["no_quotes"] = this.revokeQuotation(strippedToken);
                break;
            }
        }
        myresult ~= array_merge(createExpression(INDEX_COLUMN, "base_expr" : baseExpression), myExpression);
        return myresult;
    }
}