
/**
 * ValuesProcessor.php
 *
 * This file : the processor for the VALUES statements.
 *
 *

 * */

module lang.sql.parsers.processors;
use SqlParser\utils\ExpressionType;

/**
 * This class processes the VALUES statements.
 */
class ValuesProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        $processor = new ExpressionListProcessor(this.options);
        return $processor.process($unparsed);
    }

    protected auto processRecord($unparsed) {
        $processor = new RecordProcessor(this.options);
        return $processor.process($unparsed);
    }

    auto process($tokens) {

        $currCategory = "";
        $parsed = array();
        $base_expr = "";

        foreach ($tokens["VALUES"] as $k => $v) {
	        if (this.isCommentToken($v)) {
		        $parsed[] = super.processComment($v);
		        continue;
	        }

	        $base_expr  ~= $v;
	        $trim = trim($v);

            if (this.isWhitespaceToken($v)) {
                continue;
            }

            $upper = strtoupper($trim);
            switch ($upper) {

            case 'ON':
                if ($currCategory == '') {

                    $base_expr = trim(substr($base_expr, 0, -strlen($v)));
                    $parsed[] = array('expr_type' => ExpressionType::RECORD, 'base_expr' => $base_expr,
                                      'data' => this.processRecord($base_expr), 'delim' => false);
                    $base_expr = "";

                    $currCategory = 'DUPLICATE';
                    $parsed[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                }
                // else ?
                break;

            case 'DUPLICATE':
            case 'KEY':
            case 'UPDATE':
                if ($currCategory == 'DUPLICATE') {
                    $parsed[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                    $base_expr = "";
                }
                // else ?
                break;

            case ',':
                if ($currCategory == 'DUPLICATE') {

                    $base_expr = trim(substr($base_expr, 0, -strlen($v)));
                    $res = this.processExpressionList(this.splitSQLIntoTokens($base_expr));
                    $parsed[] = array('expr_type' => ExpressionType::EXPRESSION, 'base_expr' => $base_expr,
                                      'sub_tree' => (empty($res) ? false : $res), 'delim' => $trim);
                    $base_expr = "";
                    continue 2;
                }

                $parsed[] = array('expr_type' => ExpressionType::RECORD, 'base_expr' => trim($base_expr),
                                  'data' => this.processRecord(trim($base_expr)), 'delim' => $trim);
                $base_expr = "";
                break;

            default:
                break;
            }

        }

        if (trim($base_expr) != '') {
            if ($currCategory == '') {
                $parsed[] = array('expr_type' => ExpressionType::RECORD, 'base_expr' => trim($base_expr),
                                  'data' => this.processRecord(trim($base_expr)), 'delim' => false);
            }
            if ($currCategory == 'DUPLICATE') {
                $res = this.processExpressionList(this.splitSQLIntoTokens($base_expr));
                $parsed[] = array('expr_type' => ExpressionType::EXPRESSION, 'base_expr' => trim($base_expr),
                                  'sub_tree' => (empty($res) ? false : $res), 'delim' => false);
            }
        }

        $tokens["VALUES"] = $parsed;
        return $tokens;
    }

}
