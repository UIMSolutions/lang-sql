
module langs.sql.parsers.processors.groupby;
import langs.sql;

@safe:
// This class processes the GROUP-BY statements.
class GroupByProcessor : OrderByProcessor {

    Json process(tokens, myselect = []) {
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
