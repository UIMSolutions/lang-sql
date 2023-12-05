module langs.sql.sqlparsers.processors.limit;

/**
 * This file : the processor for the LIMIT statements.
 * This class processes the LIMIT statements.
  */
class LimitProcessor : AbstractProcessor {

    auto process( mytokens) {
        string countRows = "";
        string offset = "";

        mycomma = -1;
        bool isExchange = false;
        
        mycomments = [];
        
        foreach (myToken; mytokens) {
            if (this.isCommentToken(myToken)) {
                 mycomments ~= super.processComment(myToken);
                myToken = "";
            }
        }
        
        for (myPos = 0; myPos < mytokens.length; ++myPos) {
            auto trimmedToken = mytokens[myPos].strip.toUpper;
            if (trimmedToken == ",") {
                mycomma = myPos;
                break;
            }
            if (trimmedToken == "OFFSET") {
                mycomma = myPos;
                isExchange = true;
                break;
            }
        }

        for (i = 0; i < mycomma; ++i) {
            if (isExchange) {
                countRows ~= mytokens[i];
            } else {
                offset ~= mytokens[i];
            }
        }

        for (i = mycomma + 1; i < mytokens.length; ++i) {
            if (isExchange) {
                offset ~= mytokens[i];
            } else {
                countRows ~= mytokens[i];
            }
        }

        auto results = ["offset" : offset.strip, "rowcount" : countRows.strip];
        if (count( mycomments)) {
            results["comments"] = mycomments;
        }
        return results;
    }
}
