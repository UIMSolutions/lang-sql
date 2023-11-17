module langs.sql.sqlparsers.processors.limit;

/**
 * This file : the processor for the LIMIT statements.
 * This class processes the LIMIT statements.
  */
class LimitProcessor : AbstractProcessor {

    auto process($tokens) {
        $rowcount = "";
        $offset = "";

        $comma = -1;
        $exchange = false;
        
        $comments = [];
        
        foreach (myToken; $tokens) {
            if (this.isCommentToken(myToken)) {
                 $comments[] = super.processComment(myToken);
                 myToken = "";
            }
        }
        
        for (myPos = 0; myPos < count($tokens); ++myPos) {
            auto trimmedToken = $tokens[myPos].strip.toUpper;
            if (trimmedToken == ",") {
                $comma = myPos;
                break;
            }
            if (trimmedToken == "OFFSET") {
                $comma = myPos;
                $exchange = true;
                break;
            }
        }

        for ($i = 0; $i < $comma; ++$i) {
            if ($exchange) {
                $rowcount ~= $tokens[$i];
            } else {
                $offset ~= $tokens[$i];
            }
        }

        for ($i = $comma + 1; $i < count($tokens); ++$i) {
            if ($exchange) {
                $offset ~= $tokens[$i];
            } else {
                $rowcount ~= $tokens[$i];
            }
        }

        $return = ['offset' : $offset.strip, 'rowcount' : $rowcount.strip];
        if (count($comments)) {
            $return["comments"] = $comments;
        }
        return $return;
    }
}
