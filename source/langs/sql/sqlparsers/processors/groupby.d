
module langs.sql.sqlparsers.processors.groupby;
import lang.sql;

@safe:
// This class processes the GROUP-BY statements.
class GroupByProcessor : OrderByProcessor {

    auto process(tokens, $select = []) {
        result = [];
        $parseInfo = this.initParseInfo();

        if (!tokens) {
            return false;
        }

        foreach (myToken; tokens) {
            auto strippedToken = myToken.strip.toUpper;
            switch (strippedToken) {
            case ",":
                $parsed = this.processOrderExpression($parseInfo, $select);
                unset($parsed["direction"]);

                result[] = $parsed;
                $parseInfo = this.initParseInfo();
                break;
            default:
                $parseInfo.baseExpression ~= myToken;
                break;
            }
        }

        $parsed = this.processOrderExpression($parseInfo, $select);
        unset($parsed["direction"]);
        result[] = $parsed;

        return result;
    }
}
