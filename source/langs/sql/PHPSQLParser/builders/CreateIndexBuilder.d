
/**
 * CreateIndex.php
 *
 * Builds the CREATE INDEX statement
 *

 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the CREATE INDEX statement. You can overwrite
 * all functions to achieve another handling.
 */
class CreateIndexBuilder : ISqlBuilder {

    protected auto buildIndexType($parsed) {
        $builder = new CreateIndexTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexTable($parsed) {
        $builder = new CreateIndexTableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexOptions($parsed) {
        $builder = new CreateIndexOptionsBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = $parsed["name"];
        mySql  ~= ' ' . this.buildIndexType($parsed);
        mySql = trim(mySql);
        mySql  ~= ' ' . this.buildIndexTable($parsed);
        mySql = trim(mySql);
        mySql  ~= this.buildIndexOptions($parsed);
        return trim(mySql);
    }

}
