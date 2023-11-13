
/**
 * DirectionBuilder.php
 *
 * Builds direction (e.g. of the order-by clause).
 *
 * 
 
 * @copyright 2010-2014 Justin Swanhart and André Rothe
 * @license   http://www.debian.org/misc/bsd.license  BSD License (3 Clause)
 * @version   SVN: $Id$
 * 
 */

namespace PHPSQLParser\builders;

/**
 * This class : the builder for directions (e.g. of the order-by clause). 
 * You can overwrite all functions to achieve another handling.
 *
 */
class DirectionBuilder : IBuilder {

    auto build(array $parsed) {
        if (!isset($parsed['direction']) || $parsed['direction'] == false) {
            return "";
        }
        return (" " . $parsed['direction']);
    }
}
?>
