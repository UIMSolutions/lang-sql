
/**
 * ValuesProcessor.php
 *
 * This file : the processor for the VALUES statements.
 */

module langs.sql.PHPSQLParser.processors.values;

import lang.sql;

@safe:

/**
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

        $currCategory = "";
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

            $upper = strippedToken.toUpper;
            switch ($upper) {

            case 'ON':
                if ($currCategory.isEmpty) {

                    baseExpression = trim(substr(baseExpression, 0, -strlen(myToken)));
                    $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : baseExpression,
                                      'data' : this.processRecord(baseExpression), 'delim' : false);
                    baseExpression = "";

                    $currCategory = 'DUPLICATE';
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                }
                // else ?
                break;

            case 'DUPLICATE':
            case 'KEY':
            case 'UPDATE':
                if ($currCategory == 'DUPLICATE') {
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    baseExpression = "";
                }
                // else ?
                break;

            case ',':
                if ($currCategory == 'DUPLICATE') {

                    baseExpression = trim(substr(baseExpression, 0, -strlen(myToken)));
                    $res = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                    $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : baseExpression,
                                      "sub_tree" : (empty($res) ? false : $res), 'delim': strippedToken];
                    baseExpression = "";
                    continue 2;
                }

                $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : trim(baseExpression),
                                  'data' : this.processRecord(trim(baseExpression)), 'delim': strippedToken];
                baseExpression = "";
                break;

            default:
                break;
            }

        }

        if (trim(baseExpression) != "") {
            if ($currCategory.isEmpty) {
                $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : trim(baseExpression),
                                  'data' : this.processRecord(trim(baseExpression)), 'delim' : false);
            }
            if ($currCategory == 'DUPLICATE') {
                $res = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));
                $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : trim(baseExpression),
                                  "sub_tree" : (empty($res) ? false : $res), 'delim' : false);
            }
        }

        $tokens["VALUES"] = $parsed;
        return $tokens;
    }

}
