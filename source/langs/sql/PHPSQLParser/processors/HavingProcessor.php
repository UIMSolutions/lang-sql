
/**
 * HavingProcessor.php
 *
 * Parses the HAVING statements.

 * 
 */

module lang.sql.parsers.processors;
use SqlParser\utils\ExpressionType;

/**
 * This class : the processor for the HAVING statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class HavingProcessor : ExpressionListProcessor {
	
    auto process($tokens, $select = array()) {
        $parsed = parent::process($tokens);

        foreach ($parsed as $k => $v) {
            if ($v["expr_type"] == ExpressionType::COLREF) {
                foreach ($select as $clause) {
                    if (!isset($clause["alias"])) {
                    	continue;
                    }
                    if (!$clause["alias"]) {
                        continue;
                    }
                    if ($clause["alias"]["no_quotes"] == $v["no_quotes"]) {
                        $parsed[$k]["expr_type"] = ExpressionType::ALIAS;
                        break;
                    }
                }
            }
        }

        return $parsed;
    }
}

?>
