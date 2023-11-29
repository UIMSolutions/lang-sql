module langs.sql.sqlparsers.exceptions.unsupportedfeature;

import lang.sql;

@safe:

// Exception will occur in the SqlCreator, if the creator finds a field name, which is unknown.  */
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
