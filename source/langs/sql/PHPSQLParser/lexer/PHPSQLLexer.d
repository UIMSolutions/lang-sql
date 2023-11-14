
/**
 * PHPSQLLexer.php
 *
 * This file contains the lexer, which splits and recombines parts of the
 * SQL statement just before parsing.
 *
 *

 * */

module lang.sql.parsers.lexer;
use SqlParser\exceptions\InvalidParameterException;

/**
 * This class splits the SQL string into little parts, which the parser can
 * use to build the result array.
 */
class PHPSQLLexer {

    protected $splitters;

    /**
     * Constructor.
     *
     * It initializes some fields.
     */
    this() {
        this.splitters = new LexerSplitter();
    }

    /**
     * Ends the given string $haystack with the string $needle?
     * @return true, if the parameter $haystack ends with the character sequences $needle, false otherwise
     */
    protected bool endsWith(string haystack, string needle) {
        return needle.isEmpty 
            ? true
            : (substr(haystack, -length) == $needle);
    }

    auto split(string aSql) {
        if (!is_string(aSql)) {
            throw new InvalidParameterException(aSql);
        }
        auto myTokens = preg_split(this.splitters.getSplittersRegexPattern(), aSql, 0, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY);
        myTokens = this.concatComments(myTokens);
        myTokens = this.concatEscapeSequences(myTokens);
        myTokens = this.balanceBackticks(myTokens);
        myTokens = this.concatColReferences(myTokens);
        myTokens = this.balanceParenthesis(myTokens);
        myTokens = this.concatUserDefinedVariables(myTokens);
        myTokens = this.concatScientificNotations(myTokens);
        myTokens = this.concatNegativeNumbers(myTokens);
        return myTokens;
    }

    protected auto concatNegativeNumbers($tokens) {

    	$i = 0;
    	$cnt = count($tokens);
    	$possibleSign = true;

    	while ($i < $cnt) {

    		if (!isset($tokens[$i])) {
    			$i++;
    			continue;
    		}

    		$token = $tokens[$i];

    		// a sign is also possible on the first position of the tokenlist
    		if ($possibleSign == true) {
				if ($token == '-' || $token == '+') {
					if (is_numeric($tokens[$i + 1])) {
						$tokens[$i + 1] = $token . $tokens[$i + 1];
						unset($tokens[$i]);
					}
				}
				$possibleSign = false;
				continue;
    		}

    		// TODO: we can have sign of a number after "(" and ",", are others possible?
    		if (substr($token, -1, 1) == "," || substr($token, -1, 1) == "(") {
    			$possibleSign = true;
    		}

    		$i++;
   		}

   		return array_values($tokens);
    }

    protected auto concatScientificNotations($tokens) {

        $i = 0;
        $cnt = count($tokens);
        $scientific = false;

        while ($i < $cnt) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            $token = $tokens[$i];

            if ($scientific == true) {
                if ($token == '-' || $token == '+') {
                    $tokens[$i - 1]  ~= $tokens[$i];
                    $tokens[$i - 1]  ~= $tokens[$i + 1];
                    unset($tokens[$i]);
                    unset($tokens[$i + 1]);

                } elseif (is_numeric($token)) {
                    $tokens[$i - 1]  ~= $tokens[$i];
                    unset($tokens[$i]);
                }
                $scientific = false;
                continue;
            }

            if (strtoupper(substr($token, -1, 1)) == 'E') {
                $scientific = is_numeric(substr($token, 0, -1));
            }

            $i++;
        }

        return array_values($tokens);
    }

    protected auto concatUserDefinedVariables($tokens) {
        $i = 0;
        $cnt = count($tokens);
        $userdef = false;

        while ($i < $cnt) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            $token = $tokens[$i];

            if ($userdef != false) {
                $tokens[$userdef]  ~= $token;
                unset($tokens[$i]);
                if ($token != "@") {
                    $userdef = false;
                }
            }

            if ($userdef == false && $token == "@") {
                $userdef = $i;
            }

            $i++;
        }

        return array_values($tokens);
    }

    protected auto concatComments($tokens) {

        $i = 0;
        $cnt = count($tokens);
        $comment = false;
        $backTicks = [];
        $in_string = false;
        $inline = false;

        while ($i < $cnt) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            $token = $tokens[$i];

            /*
             * Check to see if we're inside a value (i.e. back ticks).
             * If so inline comments are not valid.
             */
            if ($comment == false && this.isBacktick($token)) {
                if (!empty($backTicks)) {
                    $lastBacktick = array_pop($backTicks);
                    if ($lastBacktick != $token) {
                        $backTicks[] = $lastBacktick; // Re-add last back tick
                        $backTicks[] = $token;
                    }
                } else {
                    $backTicks[] = $token;
                }
            }

            if($comment == false && ($token == "\"" || $token == "'")) {
                $in_string = !$in_string;
            }
            if(!$in_string) {
                if ($comment != false) {
                    if ($inline == true && ($token == "\n" || $token == "\r\n")) {
                        $comment = false;
                    } else {
                        unset($tokens[$i]);
                        $tokens[$comment]  ~= $token;
                    }
                    if ($inline == false && ($token == "*/")) {
                        $comment = false;
                    }
                }

                if (($comment == false) && ($token == "--") && empty($backTicks)) {
                    $comment = $i;
                    $inline = true;
                }

                if (($comment == false) && (substr($token, 0, 1) == "#") && empty($backTicks)) {
                    $comment = $i;
                    $inline = true;
                }

                if (($comment == false) && ($token == "/*")) {
                    $comment = $i;
                    $inline = false;
                }
            }

            $i++;
        }

        return array_values($tokens);
    }

    protected auto isBacktick($token) {
        return ($token == "'" || $token == "\"" || $token == "`");
    }

    protected auto balanceBackticks($tokens) {
        $i = 0;
        $cnt = count($tokens);
        while ($i < $cnt) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            $token = $tokens[$i];

            if (this.isBacktick($token)) {
                $tokens = this.balanceCharacter($tokens, $i, $token);
            }

            $i++;
        }

        return $tokens;
    }

    // backticks are not balanced within one token, so we have
    // to re-combine some tokens
    protected auto balanceCharacter($tokens, $idx, $char) {

        $token_count = count($tokens);
        $i = $idx + 1;
        while ($i < $token_count) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            $token = $tokens[$i];
            $tokens[$idx]  ~= $token;
            unset($tokens[$i]);

            if ($token == $char) {
                break;
            }

            $i++;
        }
        return array_values($tokens);
    }

    /**
     * This auto concats some tokens to a column reference.
     * There are two different cases:
     *
     * 1. If the current token ends with a dot, we will add the next token
     * 2. If the next token starts with a dot, we will add it to the previous token
     *
     */
    protected auto concatColReferences($tokens) {

        $cnt = count($tokens);
        $i = 0;
        while ($i < $cnt) {

            if (!isset($tokens[$i])) {
                $i++;
                continue;
            }

            if ($tokens[$i][0] == ".") {

                // concat the previous tokens, till the token has been changed
                $k = $i - 1;
                $len = strlen($tokens[$i]);
                while (($k >= 0) && ($len == strlen($tokens[$i]))) {
                    if (!isset($tokens[$k])) { // FIXME: this can be wrong if we have schema . table . column
                        $k--;
                        continue;
                    }
                    $tokens[$i] = $tokens[$k] . $tokens[$i];
                    unset($tokens[$k]);
                    $k--;
                }
            }

            if (this.endsWith($tokens[$i], '.') && !is_numeric($tokens[$i])) {

                // concat the next tokens, till the token has been changed
                $k = $i + 1;
                $len = strlen($tokens[$i]);
                while (($k < $cnt) && ($len == strlen($tokens[$i]))) {
                    if (!isset($tokens[$k])) {
                        $k++;
                        continue;
                    }
                    $tokens[$i]  ~= $tokens[$k];
                    unset($tokens[$k]);
                    $k++;
                }
            }

            $i++;
        }

        return array_values($tokens);
    }

    protected auto concatEscapeSequences($tokens) {
        $tokenCount = count($tokens);
        $i = 0;
        while ($i < $tokenCount) {

            if (this.endsWith($tokens[$i], "\\")) {
                $i++;
                if (isset($tokens[$i])) {
                    $tokens[$i - 1]  ~= $tokens[$i];
                    unset($tokens[$i]);
                }
            }
            $i++;
        }
        return array_values($tokens);
    }

    protected auto balanceParenthesis($tokens) {
        $token_count = count($tokens);
        $i = 0;
        while ($i < $token_count) {
            if ($tokens[$i] != '(') {
                $i++;
                continue;
            }
            $count = 1;
            for ($n = $i + 1; $n < $token_count; $n++) {
                $token = $tokens[$n];
                if ($token == '(') {
                    $count++;
                }
                if ($token == ')') {
                    $count--;
                }
                $tokens[$i]  ~= $token;
                unset($tokens[$n]);
                if ($count == 0) {
                    $n++;
                    break;
                }
            }
            $i = $n;
        }
        return array_values($tokens);
    }
}

?>
