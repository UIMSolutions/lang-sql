
/**
 * LimitProcessor.php
 *
 * This file : the processor for the LIMIT statements.
 */

module lang.sql.parsers.processors;

/**
 * This class processes the LIMIT statements.
 * 
 
  */
class LimitProcessor : AbstractProcessor {

    auto process($tokens) {
        $rowcount = "";
        $offset = "";

        $comma = -1;
        $exchange = false;
        
        $comments = array();
        
        foreach ($tokens as &$token) {
            if (this.isCommentToken($token)) {
                 $comments[] = super.processComment($token);
                 $token = "";
            }
        }
        
        for ($i = 0; $i < count($tokens); ++$i) {
            $trim = strtoupper(trim($tokens[$i]));
            if ($trim == ",") {
                $comma = $i;
                break;
            }
            if ($trim == "OFFSET") {
                $comma = $i;
                $exchange = true;
                break;
            }
        }

        for ($i = 0; $i < $comma; ++$i) {
            if ($exchange) {
                $rowcount  ~= $tokens[$i];
            } else {
                $offset  ~= $tokens[$i];
            }
        }

        for ($i = $comma + 1; $i < count($tokens); ++$i) {
            if ($exchange) {
                $offset  ~= $tokens[$i];
            } else {
                $rowcount  ~= $tokens[$i];
            }
        }

        $return = array('offset' => trim($offset), 'rowcount' => trim($rowcount));
        if (count($comments)) {
            $return["comments"] = $comments;
        }
        return $return;
    }
}
