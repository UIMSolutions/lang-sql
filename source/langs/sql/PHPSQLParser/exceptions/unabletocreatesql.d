module langs.sql.PHPSQLParser.exceptions.unabletocreatesql;

import lang.sql;

@safe:

/**
 * This file : the UnableToCreateSQLException class which is used within the SqlParser package.
 * This exception will occur within the PHPSQLCreator, if the creator can not find a
 * method, which can handle the current expr_type field. It could be an error within the parser
 * output or a special case has not been modelled within the creator. Please create an issue
 * in such a case. */
class UnableToCreateSQLException : Exception {

    protected $part;
    protected $partkey;
    protected $entry;
    protected $entrykey;

    this($part, $partkey, $entry, $entrykey) {
        this.part = $part;
        this.partkey = $partkey;
        this.entry = $entry;
        this.entrykey = $entrykey;
        super.(
            "unknown [" . $entrykey . "] = " . $entry[$entrykey] . " in \"" . $part . "\" [" . $partkey . "] ", 15);
    }

    auto getEntry() {
        return this.entry;
    }

    auto getEntryKey() {
        return this.entrykey;
    }

    auto getSQLPart() {
        return this.part;
    }

    auto getSQLPartKey() {
        return this.partkey;
    }
}
