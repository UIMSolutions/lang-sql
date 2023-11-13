
/**
 * DeleteBuilder.php
 *
 * Builds the DELETE statement
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the [DELETE] part. You can overwrite
 * all functions to achieve another handling.
 */
class DeleteBuilder : ISqlBuilder {

    auto build(array $parsed) {
        $sql = "DELETE ";
        $right = -1;

        if ($parsed["options"] !== false) {
            $parsed["options"].byKeyValue.each!(kv => $sql ~= kv.value+" ");
        }

        if ($parsed["tables"] !== false) {
            foreach (k, v; $parsed["tables"]) {
                $sql  ~= $v . ", ";
                $right = -2;
            }
        }

        return substr($sql, 0, $right);
    }
}
