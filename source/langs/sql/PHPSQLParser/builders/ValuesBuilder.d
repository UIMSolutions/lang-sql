
/**
 * ValuesBuilder.php
 *
 * Builds the VALUES part of the INSERT statement.

 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the VALUES part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ValuesBuilder : ISqlBuilder {

    protected auto buildRecord($parsed) {
        $builder = new RecordBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildRecord($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('VALUES', $k, $v, 'expr_type');
            }

            $sql  ~= this.getRecordDelimiter($v);
        }
        return "VALUES " . trim($sql);
    }

    protected auto getRecordDelimiter($parsed) {
        return empty($parsed["delim"]) ? ' ' : $parsed["delim"] . ' ';
    }
}
