
/**
 * CreateTableOptionsBuilder.php
 *
 * Builds the table-options statement part of CREATE TABLE.
 *
 */

module lang.sql.parsersbuilders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the table-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class CreateTableOptionsBuilder : IBuilder {

    protected auto buildExpression($parsed) {
        $builder = new SelectExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCharacterSet($parsed) {
        $builder = new CharacterSetBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCollation($parsed) {
        $builder = new CollationBuilder();
        return $builder.build($parsed);
    }

    /**
     * Returns a well-formatted delimiter string. If you don't need nice SQL,
     * you could simply return $parsed['delim'].
     * 
     * @param array $parsed The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter($parsed) {
        return ($parsed['delim'] == false ? '' : (trim($parsed['delim']) . ' '));
    }

    auto build(array $parsed) {
        if (!isset($parsed['options']) || $parsed['options'] == false) {
            return "";
        }
        $options = $parsed['options'];
        $sql = "";
        foreach ($options as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildExpression($v);
            $sql  ~= this.buildCharacterSet($v);
            $sql  ~= this.buildCollation($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE options', $k, $v, 'expr_type');
            }

            $sql  ~= this.getDelimiter($v);
        }
        return " " . substr($sql, 0, -1);
    }
}
?>
