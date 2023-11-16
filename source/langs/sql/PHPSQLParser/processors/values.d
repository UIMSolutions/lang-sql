
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
        $base_expr = "";

        foreach (myKey, myValue; $tokens["VALUES"]) {
	        if (this.isCommentToken(myValue)) {
		        $parsed[] = super.processComment(myValue);
		        continue;
	        }

	        $base_expr  ~= myValue;
	        $trim = trim(myValue);

            if (this.isWhitespaceToken(myValue)) {
                continue;
            }

            $upper = $trim.toUpper;
            switch ($upper) {

            case 'ON':
                if ($currCategory.isEmpty) {

                    $base_expr = trim(substr($base_expr, 0, -strlen(myValue)));
                    $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : $base_expr,
                                      'data' : this.processRecord($base_expr), 'delim' : false);
                    $base_expr = "";

                    $currCategory = 'DUPLICATE';
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                }
                // else ?
                break;

            case 'DUPLICATE':
            case 'KEY':
            case 'UPDATE':
                if ($currCategory == 'DUPLICATE') {
                    $parsed[] = ["expr_type" : expressionType("RESERVED"), "base_expr": $trim];
                    $base_expr = "";
                }
                // else ?
                break;

            case ',':
                if ($currCategory == 'DUPLICATE') {

                    $base_expr = trim(substr($base_expr, 0, -strlen(myValue)));
                    $res = this.processExpressionList(this.splitSQLIntoTokens($base_expr));
                    $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : $base_expr,
                                      "sub_tree" : (empty($res) ? false : $res), 'delim': $trim];
                    $base_expr = "";
                    continue 2;
                }

                $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : trim($base_expr),
                                  'data' : this.processRecord(trim($base_expr)), 'delim': $trim];
                $base_expr = "";
                break;

            default:
                break;
            }

        }

        if (trim($base_expr) != "") {
            if ($currCategory.isEmpty) {
                $parsed[] = ["expr_type" : expressionType(RECORD, "base_expr" : trim($base_expr),
                                  'data' : this.processRecord(trim($base_expr)), 'delim' : false);
            }
            if ($currCategory == 'DUPLICATE') {
                $res = this.processExpressionList(this.splitSQLIntoTokens($base_expr));
                $parsed[] = ["expr_type" : expressionType("EXPRESSION"), "base_expr" : trim($base_expr),
                                  "sub_tree" : (empty($res) ? false : $res), 'delim' : false);
            }
        }

        $tokens["VALUES"] = $parsed;
        return $tokens;
    }

}
