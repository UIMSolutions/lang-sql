/**
 * @author     mfris
 * */

namespace SqlParser;

/**
 *
 * @author  mfris
 * @package SqlParser */
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
  this(array$options) {
    this.options = $options;
  }

  bool getConsistentSubtrees() {
    return (isset(this.options[self: : CONSISTENT_SUB_TREES]) && this.options[self: : CONSISTENT_SUB_TREES]);
  }

  bool getANSIQuotes() {
    return (isset(this.options[self: : ANSI_QUOTES]) && this.options[self: : ANSI_QUOTES]);
  }
}
