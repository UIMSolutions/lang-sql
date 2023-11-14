
/**
 * ColumnListProcessor.php
 *
 * This file : the processor for column lists like in INSERT statements.
 */

module lang.sql.parsers.processors;

import lang.sql;

@safe:

/**
 * 
 * This class processes column-lists.
 * 
*/
class ColumnListProcessor : AbstractProcessor {

    auto process($tokens) {
        $columns = explode(",", $tokens);
        $cols = array();
        foreach ($columns as $k => $v) {
            $cols[] = array('expr_type' => ExpressionType::COLREF, 'base_expr' => trim($v),
                            'no_quotes' => this.revokeQuotation($v));
        }
        return $cols;
    }
}