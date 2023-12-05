
module langs.sql.sqlparsers.processors.groupby;
import lang.sql;

@safe:
// This class processes the GROUP-BY statements.
class GroupByProcessor : OrderByProcessor {

    auto process(tokens, myselect = []) {
        result = [];
        myparseInfo = this.initParseInfo();

        if (!tokens) {
            return false;
        }

        foreach (myToken; tokens) {
            auto strippedToken = myToken.strip.toUpper;
            switch (strippedToken) {
            case ",":
                myparsed = this.processOrderExpression(myparseInfo, myselect);
                unset(myparsed["direction"]);

                result ~= myparsed;
                myparseInfo = this.initParseInfo();
                break;
            default:
                myparseInfo.baseExpression ~= myToken;
                break;
            }
        }

        myparsed = this.processOrderExpression(myparseInfo, myselect);
        unset(myparsed["direction"]);
        result ~= myparsed;

        return result;
    }
}
