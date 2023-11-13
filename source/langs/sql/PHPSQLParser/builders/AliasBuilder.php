module lang.sql.parsers.builders;

/**
 * This class : the builder for aliases. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class AliasBuilder : Builder {

    auto hasAlias($parsed) {
        return isset($parsed['alias']);
    }

    auto build(array $parsed) {
        if (!isset($parsed['alias']) || $parsed['alias'] == false) {
            return "";
        }
        $sql = "";
        if ($parsed['alias']['as']) {
            $sql  ~= " AS";
        }
        $sql  ~= " " . $parsed['alias']['name'];
        return $sql;
    }
}
?>
