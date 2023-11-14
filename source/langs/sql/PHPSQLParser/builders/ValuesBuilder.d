
/**
 * ValuesBuilder.php
 *
 * Builds the VALUES part of the INSERT statement.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the VALUES part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 */
class ValuesBuilder : ISqlBuilder {

    protected auto buildRecord($parsed) {
        auto myBuilder = new RecordBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildRecord($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('VALUES', $k, $v, 'expr_type');
            }

            mySql  ~= this.getRecordDelimiter($v);
        }
        return "VALUES " . trim(mySql);
    }

    protected auto getRecordDelimiter($parsed) {
        return empty($parsed["delim"]) ? ' ' : $parsed["delim"] . ' ';
    }
}
