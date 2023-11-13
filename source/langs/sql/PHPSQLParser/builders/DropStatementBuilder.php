
/**
 * DropStatement.php
 *
 * Builds the DROP statement
 *
 *
 */

namespace PHPSQLParser\builders;

/**
 * This class : the builder for the whole DROP TABLE statement. 
 * You can overwrite all functions to achieve another handling.
 */
class DropStatementBuilder : IBuilder {

	protected auto buildDROP( $parsed ) {
		$builder = new DropBuilder();
		return $builder.build( $parsed );
	}

	auto build( array $parsed ) {
		return this.buildDROP( $parsed );
	}
}
