module langs.sql.sqlparsers.optionsx;

import lang.sql;

@safe:
final class Options {

  private Json _options;

  const string CONSISTENT_SUB_TREES = "consistent_sub_trees";
  const string ANSI_QUOTES = "ansi_quotes";

  this(Json someOptions) {
    _options =  someOptions;
  }

  bool hasConsistentSubtrees() {
    return (_options.isSet(CONSISTENT_SUB_TREES) && !_options[CONSISTENT_SUB_TREES]).isEmpty;
  }

  bool hasANSIQuotes() {
    return (_options.isSet(this.ANSI_QUOTES) && !_options[this.ANSI_QUOTES].isEmpty);
  }
}
