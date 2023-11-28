module langs.sql.sqlparsers.processors.show;

import lang.sql;

@safe:

/**
 * This class processes the SHOW statements.
 * */
class ShowProcessor : AbstractProcessor {

    private LimitProcessor _limitProcessor;

    this(Options $options) {
        super($options);
        _limitProcessor = new LimitProcessor($options);
    }

    auto process($tokens) {
        auto $resultList = [];
        auto myCategory = "";
        auto myPrevious = "";

        foreach (myKey, myToken; $tokens) {
            auto upperToken = myToken.strip.toUpper;

            if (this.isWhitespaceToken(myToken)) {
                continue;
            }

            switch (upperToken) {

            case "FROM":
                $resultList[] = createExpression("RESERVED"), "base_expr":  myToken.strip];
                if (myPrevious == "INDEX" || myPrevious == "COLUMNS") {
                    break;
                }
                myCategory = upperToken;
                break;

            case "CREATE":
            case "DATABASE":
            case "SCHEMA":
            case "FUNCTION":
            case "PROCEDURE":
            case "ENGINE":
            case "TABLE":
            case "FOR":
            case "LIKE":
            case "INDEX":
            case "COLUMNS":
            case "PLUGIN":
            case "PRIVILEGES":
            case "PROCESSLIST":
            case "LOGS":
            case "STATUS":
            case "GLOBAL":
            case "SESSION":
            case "FULL":
            case "GRANTS":
            case "INNODB":
            case "STORAGE":
            case "ENGINES":
            case "OPEN":
            case "BDB":
            case "TRIGGERS":
            case "VARIABLES":
            case "DATABASES":
            case "SCHEMAS":
            case "ERRORS":
            case "TABLES":
            case "WARNINGS":
            case "CHARACTER":
            case "SET":
            case "COLLATION":
                $resultList[] = createExpression("RESERVED"), "base_expr":  myToken.strip];
                myCategory = upperToken;
                break;

            default:
                switch (myPrevious) {
                case "LIKE":
                    $resultList[] = createExpression("CONSTANT"), "base_expr":  myToken];
                    break;
                case "LIMIT":
                    $limit = array_pop($resultList);
                    $limit["sub_tree"] = this.limitProcessor.process(array_slice($tokens, $k));
                    $resultList[] = $limit;
                    break;
                case "FROM":
                case "SCHEMA":
                case "DATABASE":
                    $resultList[] = createExpression("DATABASE"), "name" : myToken,
                        "no_quotes" : this.revokeQuotation(myToken), "base_expr":  myToken];
                    break;
                case "FOR":
                    $resultList[] = ["expr_type":  expressionType("USER"), "name" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), "base_expr":  myToken];
                    break;
                case "INDEX":
                case "COLUMNS":
                case "TABLE":
                    $resultList[] = ["expr_type":  expressionType("TABLE"), "table" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), "base_expr":  myToken];
                    myCategory = "TABLENAME";
                    break;
                case "FUNCTION":
                    if (SqlParserConstants::getInstance().isAggregateFunction(upperToken)) {
                        $expr_type = expressionType("AGGREGATE_FUNCTION");
                    } else {
                        $expr_type = expressionType("SIMPLE_FUNCTION");
                    }
                    $resultList[] = ["expr_type":  $expr_type, "name" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), "base_expr":  myToken];
                    break;
                case "PROCEDURE":
                    $resultList[] = createExpression("PROCEDURE", myToken);
                    , "name" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), ];
                    break;
                case "ENGINE":
                    $resultList[] = createExpression("ENGINE"), "name" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), "base_expr":  myToken];
                    break;
                default:
                // ignore
                    break;
                }
                break;
            }
            myPrevious = myCategory;
        }
        return $resultList;
    }
}