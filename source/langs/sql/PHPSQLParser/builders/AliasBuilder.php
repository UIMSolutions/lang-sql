module lang.sql.parsers.builders;

class AliasBuilder : Builder {

    auto hasAlias($parsed) {
        return isset($parsed["alias"]);
    }

    auto build(array $parsed) {
        if (!isset($parsed["alias"]) || $parsed["alias"] == false) {
            return "";
        }
        $sql = "";
        if ($parsed["alias"]["as"]) {
            $sql  ~= " AS";
        }
        $sql  ~= " " . $parsed["alias"]["name"];
        return $sql;
    }
}
