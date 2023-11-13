
/**
 * CreateIndexOptionsBuilder.php
 *
 * Builds index options part of a CREATE INDEX statement.
 *
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the index options of a CREATE INDEX
 * statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class CreateIndexOptionsBuilder : ISqlBuilder {

    protected auto buildIndexParser($parsed) {
        $builder = new IndexParserBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexSize($parsed) {
        $builder = new IndexSizeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexType($parsed) {
        $builder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexComment($parsed) {
        $builder = new IndexCommentBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexAlgorithm($parsed) {
        $builder = new IndexAlgorithmBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexLock($parsed) {
        $builder = new IndexLockBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["options"] == false) {
            return "";
        }
        mySql = "";
        foreach ($parsed["options"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildIndexAlgorithm($v);
            mySql  ~= this.buildIndexLock($v);
            mySql  ~= this.buildIndexComment($v);
            mySql  ~= this.buildIndexParser($v);
            mySql  ~= this.buildIndexSize($v);
            mySql  ~= this.buildIndexType($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE INDEX options', $k, $v, 'expr_type');
            }

            mySql  ~= ' ';
        }
        return ' ' . substr(mySql, 0, -1);
    }
}
