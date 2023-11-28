module langs.sql.sqlparsers.processors.limit;

/**
 * This file : the processor for the LIMIT statements.
 * This class processes the LIMIT statements.
  */
class LimitProcessor : AbstractProcessor {

    auto process($tokens) {
        string countRows = "";
        string offset = "";

        $comma = -1;
        bool isExchange = false;
        
        $comments = [];
        
        foreach (myToken; $tokens) {
            if (this.isCommentToken(myToken)) {
                 $comments[] = super.processComment(myToken);
                 myToken = "";
            }
        }
        
        for (myPos = 0; myPos < $tokens.length; ++myPos) {
            auto trimmedToken = $tokens[myPos].strip.toUpper;
            if (trimmedToken == ",") {
                $comma = myPos;
                break;
            }
            if (trimmedToken == "OFFSET") {
                $comma = myPos;
                isExchange = true;
                break;
            }
        }

        for (i = 0; i < $comma; ++i) {
            if (isExchange) {
                countRows ~= $tokens[i];
            } else {
                offset ~= $tokens[i];
            }
        }

        for (i = $comma + 1; i < $tokens.length; ++i) {
            if (isExchange) {
                offset ~= $tokens[i];
            } else {
                countRows ~= $tokens[i];
            }
        }

        auto results = ["offset" : offset.strip, "rowcount" : countRows.strip];
        if (count($comments)) {
            results["comments"] = $comments;
        }
        return results;
    }
}
