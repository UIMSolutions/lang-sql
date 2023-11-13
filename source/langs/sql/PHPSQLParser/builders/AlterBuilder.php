
namespace PHPSQLParser\builders;

/**
 * This class : the builder for the [DELETE] part. You can overwrite
 * all functions to achieve another handling.
 *
 
 
 *  
 */
class AlterBuilder : Builder
{
    auto build(array $parsed)
    {
        $sql = '';

        foreach ($parsed as $term) {
            if ($term == ' ') {
                continue;
            }

            if (substr($term, 0, 1) == '(' ||
                strpos($term, "\n") !== false) {
                $sql = rtrim($sql);
            }

            $sql  ~= $term . ' ';
        }

        $sql = rtrim($sql);

        return $sql;
    }
}
