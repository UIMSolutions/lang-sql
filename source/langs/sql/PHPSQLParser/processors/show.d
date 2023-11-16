
/**
 * ShowProcessor.php
 *
 * This file : the processor for the SHOW statements.
 */

module langs.sql.PHPSQLParser.processors.show;

import lang.sql;

@safe:

/**
 *
 * This class processes the SHOW statements.
 *

 * */
class ShowProcessor : AbstractProcessor {

    private $limitProcessor;

    this(Options $options) {
        super.($options);
        this.limitProcessor = new LimitProcessor($options);
    }

    auto process($tokens) {
        $resultList = [];
        $category = "";
        $prev = "";

        foreach ($tokens as $k : $token) {
            upperToken = $token.strip.toUpper;

            if (this.isWhitespaceToken($token)) {
                continue;
            }

            switch (upperToken) {

            case 'FROM':
                $resultList[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $token.strip);
                if ($prev == 'INDEX' || $prev == 'COLUMNS') {
                    break;
                }
                $category = upperToken;
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
                $resultList[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $token.strip);
                $category = upperToken;
                break;

            default:
                switch ($prev) {
                case 'LIKE':
                    $resultList[] = ["expr_type" : expressionType(CONSTANT, "base_expr" : $token);
                    break;
                case 'LIMIT':
                    $limit = array_pop($resultList);
                    $limit["sub_tree"] = this.limitProcessor.process(array_slice($tokens, $k));
                    $resultList[] = $limit;
                    break;
                case 'FROM':
                case 'SCHEMA':
                case 'DATABASE':
                    $resultList[] = ["expr_type" : expressionType(DATABASE, 'name' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
                    break;
                case 'FOR':
                    $resultList[] = ["expr_type" : expressionType(USER, 'name' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
                    break;
                case 'INDEX':
                case 'COLUMNS':
                case 'TABLE':
                    $resultList[] = ["expr_type" : expressionType(TABLE, 'table' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
                    $category = "TABLENAME";
                    break;
                case 'FUNCTION':
                    if (SqlParserConstants::getInstance().isAggregateFunction(upperToken)) {
                        $expr_type .isExpressionType(AGGREGATE_FUNCTION;
                    } else {
                        $expr_type .isExpressionType(SIMPLE_FUNCTION;
                    }
                    $resultList[] = ["expr_type" : $expr_type, 'name' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
                    break;
                case 'PROCEDURE':
                    $resultList[] = ["expr_type" : expressionType(PROCEDURE, 'name' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
                    break;
                case 'ENGINE':
                    $resultList[] = ["expr_type" : expressionType(ENGINE, 'name' : $token,
                                          'no_quotes' : this.revokeQuotation($token), "base_expr" : $token);
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