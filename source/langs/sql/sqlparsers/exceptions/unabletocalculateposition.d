module langs.sql.sqlparsers.exceptions.unabletocalculateposition;

import langs.sql;

@safe:

/**
 * This file : the UnableToCalculatePositionException class which is used within the SqlParser package.
 * This exception will occur, if the PositionCalculator can not find the token 
 * defined by a base_expr field within the original SQL statement. Please create 
 * an issue in such a case, it is an application error. */
class UnableToCalculatePositionException : Exception {

    protected string _needle;
    protected string _haystack;

    this(string aNeedle, string aHaystack) {
        _needle = aNeedle;
        _haystack = aHaystack;
        super("cannot calculate position of " ~ _needle ~ " within " ~ _haystack); //, 5);
    }

    @property auto getNeedle() {
        return _needle;
    }

    @property auto getHaystack() {
        return _haystack;
    }
}

