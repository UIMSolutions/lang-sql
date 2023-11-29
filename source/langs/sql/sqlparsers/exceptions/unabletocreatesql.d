module langs.sql.sqlparsers.exceptions.unabletocreatesql;

import lang.sql;

@safe:

// Exception will occur within the SqlCreator, if the creator can not find a method, which can handle the current expr_type field. 
class UnableToCreateSQLException : Exception {

  protected string _sqlPart;
  protected string _sqlPartKey;
  protected Json _entry;
  protected string _entryKey;

  this(string aSqlPart, string aSqlPartKey, Json anEntry, string anEntryKey) {
    _sqlPart = aSqlPart;
    _sqlPartKey = aSqlPartKey;
    _entry = anEntry;
    _entryKey = anEntryKey;
    super(
      "unknown [%s] = %s in \"%s\" [%s] ".format(_entryKey, anEntry[_entryKey], aSqlPart, _sqlPartKey)); // ), 15);
  }

  @property Json getEntry() {
    return _entry;
  }

  @property string entryKey() {
    return _entryKey;
  }

  @property string sqlPart() {
    return _sqlPart;
  }

  @property string sqlPartKey() {
    return _sqlPartKey;
  }
}
