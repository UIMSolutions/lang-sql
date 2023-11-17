module langs.sql.sqlparsers.exceptions.unsupportedfeature;

import lang.sql;

@safe:

/**
 * This file : the UnsupportedFeatureException class which is used within the SqlParser package.
 * This exception will occur in the PHPSQLCreator, if the creator finds
 * a field name, which is unknown. The developers have created some 
 * additional output of the parser, but the creator class has not been 
 * enhanced. Please open an issue in such a case. */
class UnsupportedFeatureException : Exception {

    protected string _key;

    this(string aKey) {
        _key = aKey;
        super(_key ~ " not implemented.", 20);
    }

    auto getKey() {
        return _key;
    }
}
