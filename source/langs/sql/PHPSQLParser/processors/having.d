
/**
 * HavingProcessor.php
 *
 * Parses the HAVING statements. */

module source.langs.sql.PHPSQLParser.processors.having;
use SqlParser\utils\ExpressionType;

/**
 * This class : the processor for the HAVING statement. 
 * You can overwrite all functions to achieve another handling. */
class HavingProcessor : ExpressionListProcessor {
	
    auto process($tokens, $select = array()) {
        $parsed = super.process($tokens);

        foreach (myKey, myValue; $parsed) {
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
