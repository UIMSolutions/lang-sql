module langs.sql.PHPSQLParser.builders.drop.builder;

import lang.sql;

@safe:

/**
 * Builds the CREATE statement 
 * This class : the builder for the [DROP] part. You can overwrite
 * all functions to achieve another handling. */
class DropBuilder : ISqlBuilder {

	protected auto buildDropIndex( $parsed ) {
		auto myBuilder = new DropIndexBuilder();

		return myBuilder.build( $parsed );
	}

	protected auto buildReserved( $parsed ) {
		auto myBuilder = new ReservedBuilder();

		return myBuilder.build( $parsed );
	}

	protected auto buildExpression( $parsed ) {
		auto myBuilder = new DropExpressionBuilder();

		return myBuilder.build( $parsed );
	}

	protected auto buildSubTree( $parsed ) {
		string mySql = "";
		foreach (myKey, myValue; $parsed["sub_tree"]) {
			auto oldLengthOfSql = mySql.length;
			mySql  ~= this.buildReserved( myValue );
			mySql  ~= this.buildExpression( myValue );

			if ( oldLengthOfSql == mySql.length ) {
				throw new UnableToCreateSQLException( 'DROP subtree', myKey, myValue, "expr_type" );
			}

			mySql  ~= " ";
		}

		return mySql;
	}

	auto build( array $parsed ) {
		$drop = $parsed["DROP"];
		string mySql  = this.buildSubTree( $drop );

		if ( $drop["expr_type"] =.isExpressionType(INDEX ) {
			mySql  ~= "" ~ this.buildDropIndex( $parsed["INDEX"] ) . " ";
		}

		return "DROP " ~ substr( mySql, 0, -1 );
	}

}

