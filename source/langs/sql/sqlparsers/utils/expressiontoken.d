

module lang.sql.parsers.utils;

import lang.sql;

@safe:

class ExpressionToken {

    private $subTree;
    private string _expression;
    private string _key;
    private _token;
    private $tokenType;
    private _trimmedToken;
    private upperToken;
    private $noQuotes;

    this(string aKey = "", string aToken = "") {
        this.subTree = false;
        _expression = "";
        _key = aKey;
        _token = aToken;
        this.tokenType = false;
        _trimmedToken = _token.strip;
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

    auto getUpper(string anIndex = null) {
        return anIndex.isNull ? this.upper : this.upper[anIndex];
    }

    auto getTrim(string anIndex = null) {
        return anIndex.isNull ? _trimmedToken : _trimmedToken[anIndex];
    }

    auto getToken(string anIndex = null) {
        return anIndex.isNull ? this.token : this.token[anIndex];
    }

    auto setNoQuotes(_token, $qchars, Options $options) {
        this.noQuotes = (_token == null) ? null : this.revokeQuotation(_token, $options);
    }

    auto setTokenType($type) {
        this.tokenType = $type;
    }

    auto endsWith($needle) {
        size_t myLength = $needle.length;
        if (myLength == 0) {
            return true;
        }

        $start = myLength * -1;
        return (substr(this.token, $start) == $needle);
    }

    auto isWhitespaceToken() {
        return (_trimmedToken.isEmpty);
    }

    auto isCommaToken() {
        return (_trimmedToken == ",");
    }

    auto isVariableToken() {
        return this.upper[0] == "@";
    }

    auto isSubQueryToken() {
        return preg_match("/^\\(\\s*(-- [\\w\\s]+\\n)?\\s*SELECT/i", _trimmedToken);
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

    private auto revokeQuotation(_token, Options $options) {
        $defProc = new DefaultProcessor($options);
        return $defProc.revokeQuotation(_token];
    }

    auto toArray() {
        STRINGAA result;
        result["expr_type"] = this.tokenType;
        result.baseExpression = this.token;
        if (!noQuotes.isEmpty) {
            result["no_quotes"] = this.noQuotes;
        }
        result["sub_tree"] = this.subTree;
        return result;
    }
}

