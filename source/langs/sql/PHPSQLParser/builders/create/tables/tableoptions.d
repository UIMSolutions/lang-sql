
/**
 * CreateTableOptionsBuilder.php
 *
 * Builds the table-options statement part of CREATE TABLE.
 * */

module source.langs.sql.PHPSQLParser.builders.create.tables.tableoptions;

import lang.sql;

@safe:

/**
 * This class : the builder for the table-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableOptionsBuilder : IBuilder {

    protected auto buildExpression($parsed) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCharacterSet($parsed) {
        auto myBuilder = new CharacterSetBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCollation($parsed) {
        auto myBuilder = new CollationBuilder();
        return myBuilderr.build($parsed);
    }

    /**
     * Returns a well-formatted delimiter string. If you don't need nice SQL,
     * you could simply return $parsed["delim"].
     * 
     * @param array $parsed The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter($parsed) {
        return ($parsed["delim"] == false ? '' : (trim($parsed["delim"]) . ' '));
    }

    auto build(array $parsed) {
        if (!isset($parsed["options"]) || $parsed["options"] == false) {
            return "";
        }
        $options = $parsed["options"];
        auto mySql = "";
        foreach ($options as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildExpression($v);
            mySql  ~= this.buildCharacterSet($v);
            mySql  ~= this.buildCollation($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE options', $k, $v, 'expr_type');
            }

            mySql  ~= this.getDelimiter($v);
        }
        return " "~ substr(mySql, 0, -1);
    }
}
