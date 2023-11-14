
/**
 * DropProcessor.php
 *
 * This file : the processor for the DROP statements.
 */

module source.langs.sql.PHPSQLParser.processors.drop;

import lang.sql;

@safe:

/**
 * This class processes the DROP statements.
 */
class DropProcessor : AbstractProcessor {

    auto process($tokenList) {
        $exists = false;
        $base_expr = "";
        $objectType = "";
        $subTree = array();
        $option = false;

        foreach ($tokenList as $token) {
            $base_expr  ~= $token;
            $trim = trim($token);

            if ($trim == '') {
                continue;
            }

            $upper = strtoupper($trim);
            switch ($upper) {
            case 'VIEW':
            case 'SCHEMA':
            case 'DATABASE':
            case 'TABLE':
                if ($objectType == '') {
                    $objectType = constant('SqlParser\utils\ExpressionType::' . $upper);
                }
                $base_expr = "";
                break;
            case 'INDEX':
	            if ( $objectType == '' ) {
		            $objectType = constant( 'SqlParser\utils\ExpressionType::' . $upper );
	            }
	            $base_expr = "";
	            break;
            case 'IF':
            case 'EXISTS':
                $exists = true;
                $base_expr = "";
                break;

            case 'TEMPORARY':
                $objectType = ExpressionType::TEMPORARY_TABLE;
                $base_expr = "";
                break;

            case 'RESTRICT':
            case 'CASCADE':
                $option = $upper;
                if (!empty($objectList)) {
                    $subTree[] = array('expr_type' => ExpressionType::EXPRESSION,
                                       'base_expr' => trim(substr($base_expr, 0, -$token.length)),
                                       'sub_tree' => $objectList);
                    $objectList = array();
                }
                $base_expr = "";
                break;

            case ',':
                $last = array_pop($objectList);
                $last["delim"] = $trim;
                $objectList[] = $last;
                continue 2;

            default:
                $object = array();
                $object["expr_type"] = $objectType;
                if ($objectType == ExpressionType::TABLE || $objectType == ExpressionType::TEMPORARY_TABLE) {
                    $object["table"] = $trim;
                    $object["no_quotes"] = false;
                    $object["alias"] = false;
                }
                $object["base_expr"] = $trim;
                $object["no_quotes"] = this.revokeQuotation($trim);
                $object["delim"] = false;

                $objectList[] = $object;
                continue 2;
            }

            $subTree[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
        }

        if (!empty($objectList)) {
            $subTree[] = array('expr_type' => ExpressionType::EXPRESSION, 'base_expr' => trim($base_expr),
                               'sub_tree' => $objectList);
        }

        return array('expr_type' => $objectType, 'option' => $option, 'if-exists' => $exists, 'sub_tree' => $subTree);
    }
}