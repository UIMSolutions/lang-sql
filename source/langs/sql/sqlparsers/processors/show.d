module langs.sql.sqlparsers.processors.show;

import lang.sql;

@safe:

/**
 * This class processes the SHOW statements.
 * */
class ShowProcessor : Processor {

    private LimitProcessor _limitProcessor;

    this(Options myoptions) {
        super(myoptions);
        _limitProcessor = new LimitProcessor(myoptions);
    }

    Json process(strig[] tokens) {
        auto myresultList = [];
        auto myCategory = "";
        auto myPrevious = "";

        foreach (myKey, myToken; mytokens) {
            auto upperToken = myToken.strip.toUpper;

            if (this.isWhitespaceToken(myToken)) {
                continue;
            }

            switch (upperToken) {

            case "FROM":
                myresultList ~= createExpression("RESERVED"), "base_expr": myToken.strip];
                if (myPrevious.any!(["INDEX", "COLUMNS"]) {
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
                myresultList ~= createExpression("RESERVED", myToken.strip);
                myCategory = upperToken;
                break;

            default:
                switch (myPrevious) {
                case "LIKE":
                    myresultList ~= createExpression("CONSTANT", myToken);
                    break;
                case "LIMIT":
                    mylimit = array_pop(myresultList);
                    mylimit["sub_tree"] ~= this.limitProcessor.process(array_slice(mytokens, myk));
                    myresultList ~= mylimit;
                    break;
                case "FROM":
                case "SCHEMA":
                case "DATABASE":
                    Json newExpression = createExpression("DATABASE", myToken)
                    newExpression["name"] = myToken;
                    newExpression["no_quotes"] = this.revokeQuotation(myToken);
                    myresultList ~= newExpression;                    , ,
                    break;
                case "FOR":
                    myresultList ~= ["expr_type":  expressionType("USER"), "name" : myToken,
                                          "no_quotes" : this.revokeQuotation(myToken), "base_expr": myToken];
                    break;
                case "INDEX":
                case "COLUMNS":
                case "TABLE":
                    Json newExpression = createExpression("TABLE", myToken);
                    newExpression["table"] = myToken;
                    newExpression["no_quotes"] = this.revokeQuotation(myToken);
                    myresultList ~= newExpression;
                    myCategory = "TABLENAME";
                    break;
                case "FUNCTION":
                    Json newExpression = SqlParserConstants::getInstance().isAggregateFunction(upperToken) 
                        ? createExpression("AGGREGATE_FUNCTION", myToken);
                        : createExpression("SIMPLE_FUNCTION", myToken);

                    newExpression["name"] = myToken;
                    newExpression["no_quotes"] = this.revokeQuotation(myToken);
                    myresultList ~= newExpression;
                    break;
                case "PROCEDURE":
                    Json newExpression = createExpression("PROCEDURE", myToken);
                    newExpression["name"] = myToken;
                    newExpression["no_quotes"] = this.revokeQuotation(myToken);
                    myresultList ~= newExpression;
                    break;
                case "ENGINE":
                    Json newExpression = createExpression("ENGINE", myToken);
                    newExpression["name"] = myToken;
                    newExpression["no_quotes"] = this.revokeQuotation(myToken);
                    myresultList ~= newExpression;
                    break;
                default:
                // ignore
                    break;
                }
                break;
            }
           myPrevious = myCategory;
        }
        return myresultList;
    }
}