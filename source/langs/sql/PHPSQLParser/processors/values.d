module langs.sql.PHPSQLParser.processors.values;

import lang.sql;

@safe:

/**
 * This file : the processor for the VALUES statements.
 * This class processes the VALUES statements.
 */
class ValuesProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto processRecord($unparsed) {
        auto myProcessor = new RecordProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    auto process($tokens) {

        string currentCategory = "";
        $parsed = [];
        auto baseExpression = "";

        foreach (myKey, myToken; $tokens["VALUES"]) {
	        if (this.isCommentToken(myToken)) {
		        $parsed[] = super.processComment(myToken);
		        continue;
	        }

	        baseExpression  ~= myToken;
	        strippedToken = myToken.strip;

            if (this.isWhitespaceToken(myToken)) {
                continue;
            }

            auto upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case 'ON':
                if (currentCategory.isEmpty) {

                    baseExpression = trim(substr(baseExpression, 0, -strlen(myToken)));
                    $parsed[] = ["expr_type" : expressionType("RECORD"), "base_expr" : baseExpression,
                                      'data' : this.processRecord(baseExpression), 'delim' : false];
                    baseExpression = "";

                    currentCategory = 'DUPLICATE';
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                }
                // else ?
                break;

            case 'DUPLICATE':
            case 'KEY':
            case 'UPDATE':
                if (currentCategory == 'DUPLICATE') {
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    baseExpression = "";
                }
                // else ?
                break;

            case ",":
                if (currentCategory == 'DUPLICATE') {

                    baseExpression = trim(substr(baseExpression, 0, -strlen(myToken)));
                    $res = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                    $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : baseExpression,
                                      "sub_tree" : (empty($res) ? false : $res), 'delim': strippedToken];
                    baseExpression = "";
                    continue 2;
                }

                $parsed[] = ["expr_type" : expressionType("RECORD"), "base_expr" : baseExpression.strip,
                                  'data' : this.processRecord(baseExpression.strip), 'delim': strippedToken];
                baseExpression = "";
                break;

            default:
                break;
            }

        }

        if (!baseExpression.strip.isEmpty) {
            if (currentCategory.isEmpty) {
                $parsed[] = ["expr_type" : expressionType("RECORD"), "base_expr" : baseExpression.strip,
                                  'data' : this.processRecord(baseExpression.strip), 'delim' : false];
            }
            if (currentCategory == 'DUPLICATE') {
                $res = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : baseExpression.strip,
                                  "sub_tree" : ($res.isEmpty ? false : $res), 'delim' : false];
            }
        }

        $tokens["VALUES"] = $parsed;
        return $tokens;
    }

}
