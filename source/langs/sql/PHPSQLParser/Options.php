
/**
 * @author     mfris
 *
 */

namespace PHPSQLParser;

/**
 *
 * @author  mfris
 * @package PHPSQLParser
 */
final class Options
{

    /**
     * @var array
     */
    private $options;

    /**
     * @const string
     */
    const CONSISTENT_SUB_TREES = 'consistent_sub_trees';

    /**
     * @const string
     */
    const ANSI_QUOTES = 'ansi_quotes';

    /**
     * Options constructor.
     *
     * @param array $options
     */
    this(array $options)
    {
        this.options = $options;
    }

    /**
     * @return bool
     */
    auto getConsistentSubtrees()
    {
        return (isset(this.options[self::CONSISTENT_SUB_TREES]) && this.options[self::CONSISTENT_SUB_TREES]);
    }

    /**
     * @return bool
     */
    auto getANSIQuotes()
    {
        return (isset(this.options[self::ANSI_QUOTES]) && this.options[self::ANSI_QUOTES]);
    }
}
