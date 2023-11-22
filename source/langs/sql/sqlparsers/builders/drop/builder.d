module langs.sql.sqlparsers.builders.drop.builder;

import lang.sql;

@safe:

/**
 * Builds the CREATE statement 
 * This class : the builder for the [DROP] part. You can overwrite
 * all functions to achieve another handling. */
class DropBuilder : ISqlBuilder {

	protected auto buildDropIndex( parsedSQL ) {
		auto myBuilder = new DropIndexBuilder();

		return myBuilder.build( parsedSQL );
	}

	protected auto buildReserved( parsedSQL ) {
		auto myBuilder = new ReservedBuilder();

		return myBuilder.build( parsedSQL );
	}

	protected auto buildExpression( parsedSQL ) {
		auto myBuilder = new DropExpressionBuilder();

		return myBuilder.build( parsedSQL );
	}

	protected auto buildSubTree( parsedSQL ) {
		string mySql = "";
		foreach (myKey, myValue; parsedSQL["sub_tree"]) {
			auto oldLengthOfSql = mySql.length;
			mySql ~= this.buildReserved( myValue );
			mySql ~= this.buildExpression( myValue );

			if ( oldLengthOfSql == mySql.length ) {
				throw new UnableToCreateSQLException( "DROP subtree", myKey, myValue, "expr_type" );
			}

			mySql ~= " ";
		}

		return mySql;
	}

	auto build( Json parsedSQL ) {
		$drop = parsedSQL["DROP"];
		string mySql  = this.buildSubTree( $drop );

		if ( $drop["expr_type"] =.isExpressionType(INDEX ) {
			mySql ~= "" ~ this.buildDropIndex( parsedSQL["INDEX"] ) . " ";
		}

		return "DROP " ~ substr( mySql, 0, -1 );
	}

}

