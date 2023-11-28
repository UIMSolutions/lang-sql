module langs.sql.sqlparsers.exceptions.unabletocreatesql;

import lang.sql;

@safe:

/**
 * This exception will occur within the PHPSQLCreator, if the creator can not find a
 * method, which can handle the current expr_type field. It could be an error within the parser
 * output or a special case has not been modelled within the creator. Please create an issue
 * in such a case. */
class UnableToCreateSQLException : Exception {

    protected  mypart;
    protected  mypartkey;
    protected  myentry;
    protected  myentrykey;

    this( mypart,  mypartkey,  myentry,  myentrykey) {
        this.part =  mypart;
        this.partkey =  mypartkey;
        this.entry =  myentry;
        this.entrykey =  myentrykey;
        super(
            "unknown [" ~  myentrykey ~ "] = " ~  myentry[ myentrykey] ~ " in \"" ~  mypart ~ "\" [" ~  mypartkey ~ "] ", 15);
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
