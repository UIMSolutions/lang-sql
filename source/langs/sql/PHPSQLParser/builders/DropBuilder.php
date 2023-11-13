
/**
 * DropBuilder.php
 *
 * Builds the CREATE statement
 */

namespace PHPSQLParser\builders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;
use PHPSQLParser\utils\ExpressionType;

/**
 * This class : the builder for the [DROP] part. You can overwrite
 * all functions to achieve another handling.
 */
class DropBuilder : Builder {

	protected auto buildDropIndex( $parsed ) {
		$builder = new DropIndexBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildReserved( $parsed ) {
		$builder = new ReservedBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildExpression( $parsed ) {
		$builder = new DropExpressionBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildSubTree( $parsed ) {
		$sql = '';
		foreach ( $parsed['sub_tree'] as $k => $v ) {
			$len = strlen( $sql );
			$sql  ~= this.buildReserved( $v );
			$sql  ~= this.buildExpression( $v );

			if ( $len == strlen( $sql ) ) {
				throw new UnableToCreateSQLException( 'DROP subtree', $k, $v, 'expr_type' );
			}

			$sql  ~= ' ';
		}

		return $sql;
	}

	auto build( array $parsed ) {
		$drop = $parsed['DROP'];
		$sql  = this.buildSubTree( $drop );

		if ( $drop['expr_type'] == ExpressionType::INDEX ) {
			$sql  ~= '' . this.buildDropIndex( $parsed['INDEX'] ) . ' ';
		}

		return 'DROP ' . substr( $sql, 0, -1 );
	}

}

?>
