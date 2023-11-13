

module lang.sql.parsersutils;

use PHPSQLParser\Options;
use PHPSQLParser\processors\DefaultProcessor;

class ExpressionToken {

    private $subTree;
    private $expression;
    private $key;
    private $token;
    private $tokenType;
    private $trim;
    private $upper;
    private $noQuotes;

    this($key = "", $token = "") {
        this.subTree = false;
        this.expression = "";
        this.key = $key;
        this.token = $token;
        this.tokenType = false;
        this.trim = trim($token);
        this.upper = strtoupper(this.trim);
        this.noQuotes = null;
    }

    # TODO: we could replace it with a constructor new ExpressionToken(this, "*")
    auto addToken($string) {
        this.token  ~= $string;
    }

    auto isEnclosedWithinParenthesis() {
        return (!empty( this.upper ) && this.upper[0] == '(' && substr(this.upper, -1) == ')');
    }

    auto setSubTree($tree) {
        this.subTree = $tree;
    }

    auto getSubTree() {
        return this.subTree;
    }

    auto getUpper($idx = false) {
        return $idx !== false ? this.upper[$idx] : this.upper;
    }

    auto getTrim($idx = false) {
        return $idx !== false ? this.trim[$idx] : this.trim;
    }

    auto getToken($idx = false) {
        return $idx !== false ? this.token[$idx] : this.token;
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
        return (this.trim == "");
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
        return this.tokenType == ExpressionType::EXPRESSION;
    }

    auto isBracketExpression() {
        return this.tokenType == ExpressionType::BRACKET_EXPRESSION;
    }

    auto isOperator() {
        return this.tokenType == ExpressionType::OPERATOR;
    }

    auto isInList() {
        return this.tokenType == ExpressionType::IN_LIST;
    }

    auto isFunction() {
        return this.tokenType == ExpressionType::SIMPLE_FUNCTION;
    }

    auto isUnspecified() {
        return (this.tokenType == false);
    }

    auto isVariable() {
        return this.tokenType == ExpressionType::GLOBAL_VARIABLE || this.tokenType == ExpressionType::LOCAL_VARIABLE || this.tokenType == ExpressionType::USER_VARIABLE;
    }

    auto isAggregateFunction() {
        return this.tokenType == ExpressionType::AGGREGATE_FUNCTION;
    }

    auto isCustomFunction() {
        return this.tokenType == ExpressionType::CUSTOM_FUNCTION;
    }

    auto isColumnReference() {
        return this.tokenType == ExpressionType::COLREF;
    }

    auto isConstant() {
        return this.tokenType == ExpressionType::CONSTANT;
    }

    auto isSign() {
        return this.tokenType == ExpressionType::SIGN;
    }

    auto isSubQuery() {
        return this.tokenType == ExpressionType::SUBQUERY;
    }

    private auto revokeQuotation($token, Options $options) {
        $defProc = new DefaultProcessor($options);
        return $defProc.revokeQuotation($token);
    }

    auto toArray() {
        $result = array();
        $result['expr_type'] = this.tokenType;
        $result['base_expr'] = this.token;
        if (!empty(this.noQuotes)) {
            $result['no_quotes'] = this.noQuotes;
        }
        $result['sub_tree'] = this.subTree;
        return $result;
    }
}

?>
