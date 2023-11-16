module lang.sql.parsers.utils;

/**
 * Defines all values, which are possible for the [expr_type] field within the parser output. */
 * This class defines all values, which are possible for the [expr_type] field 
 * within the parser output.
 */
class ExpressionType {

    const USER_VARIABLE = 'user_variable';
    const SESSION_VARIABLE = 'session_variable';
    const GLOBAL_VARIABLE = 'global_variable';
    const LOCAL_VARIABLE = 'local_variable';

    const COLDEF = 'column-def';
    const COLREF = 'colref';
    const RESERVED = 'reserved';
    const CONSTANT = 'const';

    const AGGREGATE_auto = 'aggregate_function';
    const CUSTOM_auto = 'custom_function';

    const SIMPLE_auto = 'function';

    const EXPRESSION = 'expression';
    const BRACKET_EXPRESSION = 'bracket_expression';
    const TABLE_EXPRESSION = 'table_expression';

    const SUBQUERY = 'subquery';
    const IN_LIST = 'in-list';
    const OPERATOR = 'operator';
    const SIGN = 'sign';
    const RECORD = 'record';

    const MATCH_ARGUMENTS = 'match-arguments';
    const MATCH_MODE = 'match-mode';

    const ALIAS = 'alias';
    const POSITION = 'pos';

    const TEMPORARY_TABLE = 'temporary-table';
    const TABLE = 'table';
    const VIEW = 'view';
    const DATABASE = 'database';
    const SCHEMA = 'schema';

    const PROCEDURE = 'procedure';
    const ENGINE = 'engine';
    const USER = 'user';
    const DIRECTORY = 'directory';
    const UNION = 'union';
    const CHARSET = 'character-set';
    const COLLATE = 'collation';

    const LIKE = 'like';
    const CONSTRAINT = 'constraint';
    const PRIMARY_KEY = 'primary-key';
    const FOREIGN_KEY = 'foreign-key';
    const UNIQUE_IDX = 'unique-index';
    const INDEX = 'index';
    const FULLTEXT_IDX = 'fulltext-index';
    const SPATIAL_IDX = 'spatial-index';
    const INDEX_TYPE = 'index-type';
    const CHECK = 'check';
    const COLUMN_LIST = 'column-list';
    const INDEX_COLUMN = 'index-column';
    const INDEX_SIZE = 'index-size';
    const INDEX_PARSER = 'index-parser';
    const INDEX_ALGORITHM = 'index-algorithm';
    const INDEX_LOCK = 'index-lock';
    const REFERENCE = 'foreign-ref';

    const DATA_TYPE = 'data-type';
    const COLUMN_TYPE = 'column-type';
    const DEF_VALUE = 'default-value';
    const COMMENT = 'comment';
    
    const PARTITION = 'partition';
    const PARTITION_LIST = 'partition-list';
    const PARTITION_RANGE = 'partition-range';
    const PARTITION_HASH = 'partition-hash';
    const PARTITION_KEY = 'partition-key';
    const PARTITION_COUNT = 'partition-count';
    const PARTITION_DEF = 'partition-def';
    const PARTITION_VALUES = 'partition-values';
    const PARTITION_COMMENT = 'partition-comment';
    const PARTITION_INDEX_DIR = 'partition-index-dir';
    const PARTITION_DATA_DIR = 'partition-data-dir';
    const PARTITION_MAX_ROWS = 'partition-max-rows';
    const PARTITION_MIN_ROWS = 'partition-min-rows';
    const PARTITION_KEY_ALGORITHM = 'partition-key-algorithm';
    
    const SUBPARTITION = 'sub-partition';
    const SUBPARTITION_DEF = 'sub-partition-def';
    const SUBPARTITION_HASH = 'sub-partition-hash';
    const SUBPARTITION_KEY = 'sub-partition-key';
    const SUBPARTITION_COUNT = 'sub-partition-count';
    const SUBPARTITION_COMMENT = 'sub-partition-comment';
    const SUBPARTITION_INDEX_DIR = 'sub-partition-index-dir';
    const SUBPARTITION_DATA_DIR = 'sub-partition-data-dir';
    const SUBPARTITION_MAX_ROWS = 'sub-partition-max-rows';
    const SUBPARTITION_MIN_ROWS = 'sub-partition-min-rows';
    const SUBPARTITION_KEY_ALGORITHM = 'sub-partition-key-algorithm';
    
    const QUERY = 'query';
    const SUBQUERY_FACTORING = 'subquery-factoring';
}
