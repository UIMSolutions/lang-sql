module langs.sql.sqlparsers.processors.insert;

import lang.sql;

@safe:

// This class processes the INSERT statements.
class InsertProcessor : AbstractProcessor {

    protected auto processOptions(mytokenList) {
        if (! mytokenList.isSet("OPTIONS")) {
            return [];
        }
        }
        myresult = [];
        foreach (mytokenList["OPTIONS"] as mytoken) {
            myresult ~= createExpression("RESERVED", "base_expr" : mytoken.strip);
        }
        return myresult;
    }

    protected auto processKeyword(myKeyword, mytokenList) {
        if (! mytokenList.isSet(myKeyword)) {
            return ["", false, []);
        }

        string myTable = "";
        mycols = false;
        myresult = [];

        foreach (mytoken; mytokenList[myKeyword]) {
            auto strippedToken = myToken.strip;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {
            case "INTO":
                myresult ~= createExpression("RESERVED", strippedToken];
                break;

            case "INSERT":
            case "REPLACE":
                break;

            default:
                if (myTable.isEmpty) {
                   myTable = strippedToken;
                    break;
                }

                if (mycols == false) {
                    mycols = strippedToken;
                }
                break;
            }
        }
        return [myTable, mycols, myresult);
    }

    protected auto processColumns(mycols) {
        if (mycols == false) {
            return mycols;
        }
        if (mycols[0] == "(" && substr(mycols, -1) == ")") {
            myparsed = createExpression("BRACKET_EXPRESSION"), "base_expr" : mycols,
                            "sub_tree" : false];
        }
        mycols = this.removeParenthesisFromStart(mycols);
        if (stripos(mycols, "SELECT") == 0) {
            auto myProcessor = new DefaultProcessor(this.options);
            myparsed["sub_tree"] = [
                    createExpression("QUERY"), "base_expr" : mycols,
                            "sub_tree" : myprocessor.process(mycols)));
        } else {
            auto myProcessor = new ColumnListProcessor(this.options);
            myparsed["sub_tree"] = myprocessor.process(mycols);
            myparsed["expr_type"] .isExpressionType("COLUMN_LIST");
        }
        return myparsed;
    }

    auto process(mytokenList, mytoken_category = "INSERT") {
        string myTable = "";
        mycols = false;
        mycomments = [];

        foreach (myKey : & mytoken; mytokenList) {
            if (myKey == "VALUES") {
                continue;
            }
            foreach (& myvalue; mytoken as ) {
                if (this.isCommentToken(myvalue)) {
                     mycomments ~= super.processComment(myvalue);
                     myvalue = "";
                }
            }
        }

        myparsed = this.processOptions(mytokenList);
        unset(mytokenList["OPTIONS"]);

        list(myTable, mycols, myKey) = this.processKeyword("INTO", mytokenList);
        myparsed = array_merge(myparsed, myKey);
        unset(mytokenList["INTO"]);

        if (myTable.isEmpty && in_array(mytoken_category, ["INSERT", "REPLACE"))) {
            list(myTable, mycols, myKey) = this.processKeyword(mytoken_category, mytokenList);
        }

        myparsed ~= createExpression(TABLE, "table" : myTable,
                          "no_quotes" : this.revokeQuotation(myTable), "alias" : false, "base_expr" : myTable);

        mycols = this.processColumns(mycols);
        if (mycols != false) {
            myparsed ~= mycols;
        }

        myparsed = array_merge(myparsed, mycomments);

        mytokenList[mytoken_category] = myparsed;
        return mytokenList;
    }
}
