module langs.sql.PHPSQLParser.processors.subpartitiondefinition;

import lang.sql;

@safe:

/**
 * This file : the processor for the SUBPARTITION statements within CREATE TABLE.
 * This class processes the SUBPARTITION statements within CREATE TABLE. */
class SubpartitionDefinitionProcessor : AbstractProcessor {

    protected auto getReservedType($token) {
        return ["expr_type" : expressionType("RESERVED"), "base_expr" : $token];
    }

    protected auto getConstantType($token) {
        return ["expr_type" : expressionType(CONSTANT, "base_expr" : $token];
    }

    protected auto getOperatorType($token) {
        return ["expr_type" : expressionType(OPERATOR, "base_expr" : $token];
    }

    protected auto getBracketExpressionType($token) {
        return ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $token, "sub_tree" : false];
    }

    auto process($tokens) {

        $result = [];
        $prevCategory = "";
        $currCategory = "";
        $parsed = [];
        $expr = [];
        baseExpression = "";
        $skip = 0;

        foreach ($tokenKey, $token; $tokens) {
            auto strippedToken = $token.strip;
            baseExpression  ~= $token;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case 'SUBPARTITION':
                if ($currCategory.isEmpty) {
                    $expr[] = this.getReservedType(strippedToken);
                    $parsed = ["expr_type" : expressionType(SUBPARTITION_DEF, "base_expr" : baseExpression.strip,
                                    "sub_tree" : false];
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'COMMENT':
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = ["expr_type" : expressionType(SUBPARTITION_COMMENT, "base_expr" : false,
                                    "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'STORAGE':
                if ($prevCategory == 'SUBPARTITION') {
                    // followed by ENGINE
                    $expr[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'ENGINE':
                if ($currCategory == 'STORAGE') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = upperToken;
                    continue 2;
                }
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));
                    
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case '=':
                if (in_array($currCategory, ['ENGINE', 'COMMENT', 'DIRECTORY', 'MAX_ROWS', 'MIN_ROWS'))) {
                    $expr[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ',':
                if ($prevCategory == 'SUBPARTITION' && $currCategory.isEmpty) {
                    // it separates the subpartition-definitions
                    $result[] = $parsed;
                    $parsed = [];
                    baseExpression = "";
                    $expr = [];
                }
                break;

            case 'DATA':
            case 'INDEX':
                if ($prevCategory == 'SUBPARTITION') {
                    // followed by DIRECTORY
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(SUBPARTITION_' . upperToken . '_DIR'),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'DIRECTORY':
                if ($currCategory == 'DATA' || $currCategory == 'INDEX') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'MAX_ROWS':
            case 'MIN_ROWS':
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(SUBPARTITION_' . upperToken),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            default:
                switch ($currCategory) {

                case 'MIN_ROWS':
                case 'MAX_ROWS':
                case 'ENGINE':
                case 'DIRECTORY':
                case 'COMMENT':
                    $expr[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = $expr;
                    $last["base_expr"] = baseExpression.strip;
                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = baseExpression.strip;
                    $expr = $parsed["sub_tree"];
                    unset($last);

                    $currCategory = $prevCategory;
                    break;

                case 'SUBPARTITION':
                // that is the subpartition name
                    $last = array_pop($expr);
                    $last["name"] = strippedToken;
                    $expr[] = $last;
                    $expr[] = this.getConstantType(strippedToken);
                    $parsed["sub_tree"] = $expr;
                    $parsed["base_expr"] = baseExpression.strip;
                    break;

                default:
                    break;
                }
                break;
            }

            $prevCategory = $currCategory;
            $currCategory = "";
        }

        $result[] = $parsed;
        return $result;
    }
}
