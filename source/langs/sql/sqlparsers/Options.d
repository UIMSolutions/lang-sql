module langs.sql.sqlparsers.optionsx;

import lang.sql;

@safe:
final class Options {

  private  myoptions;

  const string CONSISTENT_SUB_TREES = "consistent_sub_trees";

  const string ANSI_QUOTES = "ansi_quotes";

  this(array  myoptions) {
    this.options =  myoptions;
  }

  bool getConsistentSubtrees() {
    return (this.options.isSet(this.CONSISTENT_SUB_TREES) && this.options[this.CONSISTENT_SUB_TREES]);
  }

  bool getANSIQuotes() {
    return (this.options.isSet(this.ANSI_QUOTES) && this.options[this.ANSI_QUOTES]);
  }
}
