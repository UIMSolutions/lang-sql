

module lang.sql.parsers.utils;

import lang.sql;

@safe:

class ExpressionToken {

    private $subTree;
    private $expression;
    private $key;
    private $token;
    private $tokenType;
    private $trim;
    private upperToken;
    private $noQuotes;

    this($key = "", $token = "") {
        this.subTree = false;
        this.expression = "";
        this.key = $key;
        this.token = $token;
        this.tokenType = false;
        this.trim = $token.strip;
        this.trim);
        this.noQuotes = null;
    }

    # TODO: we could replace it with a constructor new ExpressionToken(this, "*")
    auto addToken($string) {
        this.token ~= $string;
    }

    auto isEnclosedWithinParenthesis() {
        return (!empty( this.upper ) && this.upper[0] == "(" && substr(this.upper, -1) == ")");
    }

    auto setSubTree($tree) {
        this.subTree = $tree;
    }

    auto getSubTree() {
        return this.subTree;
    }

    auto getUpper($idx = false) {
        return $idx != false ? this.upper[$idx] : this.upper;
    }

    auto getTrim($idx = false) {
        return $idx != false ? this.trim[$idx] : this.trim;
    }

    auto getToken($idx = false) {
        return $idx != false ? this.token[$idx] : this.token;
    }

    auto setNoQuotes($token, $qchars, Options $options) {
        this.noQuotes = ($token == null) ? null : this.revokeQuotation($token, $options);
    }

    auto setTokenType($type) {
        this.tokenType = $type;
    }

    auto endsWith($needle) {
        $length = strlen($needle);
        if ($length == 0) {
            return true;
        }

        $start = $length * -1;
        return (substr(this.token, $start) == $needle);
    }

    auto isWhitespaceToken() {
        return (this.trim.isEmpty);
    }

    auto isCommaToken() {
        return (this.trim == ",");
    }

    auto isVariableToken() {
        return this.upper[0] == '@';
    }

    auto isSubQueryToken() {
        return preg_match("/^\\(\\s*(-- [\\w\\s]+\\n)?\\s*SELECT/i", this.trim);
    }

    auto isExpression() {
        return this.tokenType =.isExpressionType(EXPRESSION;
    }

    auto isBracketExpression() {
        return this.tokenType =.isExpressionType(BRACKET_EXPRESSION;
    }

    auto isOperator() {
        return this.tokenType =.isExpressionType(OPERATOR;
    }

    auto isInList() {
        return this.tokenType =.isExpressionType(IN_LIST;
    }

    auto isFunction() {
        return this.tokenType =.isExpressionType(SIMPLE_FUNCTION;
    }

    auto isUnspecified() {
        return (this.tokenType == false);
    }

    auto isVariable() {
        return this.tokenType =.isExpressionType(GLOBAL_VARIABLE || this.tokenType =.isExpressionType(LOCAL_VARIABLE || this.tokenType =.isExpressionType(USER_VARIABLE;
    }

    auto isAggregateFunction() {
        return this.tokenType =.isExpressionType(AGGREGATE_FUNCTION;
    }

    auto isCustomFunction() {
        return this.tokenType =.isExpressionType(CUSTOM_FUNCTION;
    }

    auto isColumnReference() {
        return this.tokenType =.isExpressionType(COLREF;
    }

    auto isConstant() {
        return this.tokenType =.isExpressionType(CONSTANT;
    }

    auto isSign() {
        return this.tokenType =.isExpressionType(SIGN;
    }

    auto isSubQuery() {
        return this.tokenType =.isExpressionType(SUBQUERY;
    }

    private auto revokeQuotation($token, Options $options) {
        $defProc = new DefaultProcessor($options);
        return $defProc.revokeQuotation($token];
    }

    auto toArray() {
        $result = [];
        $result["expr_type"] = this.tokenType;
        $result["base_expr"] = this.token;
        if (!empty(this.noQuotes)) {
            $result["no_quotes"] = this.noQuotes;
        }
        $result["sub_tree"] = this.subTree;
        return $result;
    }
}

