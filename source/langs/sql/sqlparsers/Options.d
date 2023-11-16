/**
 * @author     mfris
 * */

namespace SqlParser;

import lang.sql;

@safe:
final class Options {

  /**
     * @var array
     */
  private$options;

  const string CONSISTENT_SUB_TREES = "consistent_sub_trees";

  const string ANSI_QUOTES = "ansi_quotes";

  /**
     * Options constructor.
     *
     * @param array $options
     */
  this(array $options) {
    this.options = $options;
  }

  bool getConsistentSubtrees() {
    return (this.options.isSet(this.CONSISTENT_SUB_TREES) && this.options[this.CONSISTENT_SUB_TREES]);
  }

  bool getANSIQuotes() {
    return (this.options.isSet(this.ANSI_QUOTES) && this.options[this.ANSI_QUOTES]);
  }
}
