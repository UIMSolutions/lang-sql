
/**
 * DropBuilder.php
 *
 * Builds the CREATE statement
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the [DROP] part. You can overwrite
 * all functions to achieve another handling.
 */
class DropBuilder : ISqlBuilder {

	protected auto buildDropIndex( $parsed ) {
		auto myBuilder = new DropIndexBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildReserved( $parsed ) {
		auto myBuilder = new ReservedBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildExpression( $parsed ) {
		auto myBuilder = new DropExpressionBuilder();

		return $builder.build( $parsed );
	}

	protected auto buildSubTree( $parsed ) {
		mySql = "";
		foreach ( $parsed["sub_tree"] as $k => $v ) {
			$len = strlen( mySql );
			mySql  ~= this.buildReserved( $v );
			mySql  ~= this.buildExpression( $v );

			if ( $len == strlen( mySql ) ) {
				throw new UnableToCreateSQLException( 'DROP subtree', $k, $v, 'expr_type' );
			}

			mySql  ~= ' ';
		}

		return mySql;
	}

	auto build( array $parsed ) {
		$drop = $parsed["DROP"];
		mySql  = this.buildSubTree( $drop );

		if ( $drop["expr_type"] == ExpressionType::INDEX ) {
			mySql  ~= '' . this.buildDropIndex( $parsed["INDEX"] ) . ' ';
		}

		return 'DROP ' . substr( mySql, 0, -1 );
	}

}

?>
