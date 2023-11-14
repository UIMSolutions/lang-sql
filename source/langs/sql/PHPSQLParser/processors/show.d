
/**
 * ShowProcessor.php
 *
 * This file : the processor for the SHOW statements.
 */

module source.langs.sql.PHPSQLParser.processors.show;

import lang.sql;

@safe:

/**
 *
 * This class processes the SHOW statements.
 *
 * @author arothe
 * */
class ShowProcessor : AbstractProcessor {

    private $limitProcessor;

    this(Options $options) {
        super.($options);
        this.limitProcessor = new LimitProcessor($options);
    }

    auto process($tokens) {
        $resultList = array();
        $category = "";
        $prev = "";

        foreach ($tokens as $k => $token) {
            $upper = strtoupper(trim($token));

            if (this.isWhitespaceToken($token)) {
                continue;
            }

            switch ($upper) {

            case 'FROM':
                $resultList[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => trim($token));
                if ($prev == 'INDEX' || $prev == 'COLUMNS') {
                    break;
                }
                $category = $upper;
                break;

            case 'CREATE':
            case 'DATABASE':
            case 'SCHEMA':
            case 'FUNCTION':
            case 'PROCEDURE':
            case 'ENGINE':
            case 'TABLE':
            case 'FOR':
            case 'LIKE':
            case 'INDEX':
            case 'COLUMNS':
            case 'PLUGIN':
            case 'PRIVILEGES':
            case 'PROCESSLIST':
            case 'LOGS':
            case 'STATUS':
            case 'GLOBAL':
            case 'SESSION':
            case 'FULL':
            case 'GRANTS':
            case 'INNODB':
            case 'STORAGE':
            case 'ENGINES':
            case 'OPEN':
            case 'BDB':
            case 'TRIGGERS':
            case 'VARIABLES':
            case 'DATABASES':
            case 'SCHEMAS':
            case 'ERRORS':
            case 'TABLES':
            case 'WARNINGS':
            case 'CHARACTER':
            case 'SET':
            case 'COLLATION':
                $resultList[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => trim($token));
                $category = $upper;
                break;

            default:
                switch ($prev) {
                case 'LIKE':
                    $resultList[] = array('expr_type' => ExpressionType::CONSTANT, 'base_expr' => $token);
                    break;
                case 'LIMIT':
                    $limit = array_pop($resultList);
                    $limit["sub_tree"] = this.limitProcessor.process(array_slice($tokens, $k));
                    $resultList[] = $limit;
                    break;
                case 'FROM':
                case 'SCHEMA':
                case 'DATABASE':
                    $resultList[] = array('expr_type' => ExpressionType::DATABASE, 'name' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    break;
                case 'FOR':
                    $resultList[] = array('expr_type' => ExpressionType::USER, 'name' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    break;
                case 'INDEX':
                case 'COLUMNS':
                case 'TABLE':
                    $resultList[] = array('expr_type' => ExpressionType::TABLE, 'table' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    $category = "TABLENAME";
                    break;
                case 'FUNCTION':
                    if (SqlParserConstants::getInstance().isAggregateFunction($upper)) {
                        $expr_type = ExpressionType::AGGREGATE_FUNCTION;
                    } else {
                        $expr_type = ExpressionType::SIMPLE_FUNCTION;
                    }
                    $resultList[] = array('expr_type' => $expr_type, 'name' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    break;
                case 'PROCEDURE':
                    $resultList[] = array('expr_type' => ExpressionType::PROCEDURE, 'name' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    break;
                case 'ENGINE':
                    $resultList[] = array('expr_type' => ExpressionType::ENGINE, 'name' => $token,
                                          'no_quotes' => this.revokeQuotation($token), 'base_expr' => $token);
                    break;
                default:
                // ignore
                    break;
                }
                break;
            }
            $prev = $category;
        }
        return $resultList;
    }
}