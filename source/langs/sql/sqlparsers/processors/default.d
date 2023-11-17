module langs.sql.sqlparsers.processors.default;

/**
 * This file : the processor the unparsed sql string given by the user.
 * This class processes the incoming sql string.
 */
class DefaultProcessor : AbstractProcessor {

  protected auto isUnion($tokens) {
    return UnionProcessor : : isUnion($tokens);
  }

  protected auto processUnion($tokens) {
    // this is the highest level lexical analysis. This is the part of the
    // code which finds UNION and UNION ALL query parts
    auto myProcessor = new UnionProcessor(this.options);
    return myProcessor.process($tokens);
  }

  protected auto processSQL($tokens) {
    auto myProcessor = new SQLProcessor(this.options);
    return myProcessor.process($tokens);
  }

  auto process($sql) {

    auto myInputArray = this.splitSQLIntoTokens($sql);
    auto myQueries = this.processUnion(myInputArray);

    // If there was no UNION or UNION ALL in the query, then the query is
    // stored at myQueries[0].
    if (!empty(myQueries) && !this.isUnion(myQueries)) {
      myQueries = this.processSQL(myQueries[0]);
    }

    return myQueries;
  }

  auto revokeQuotation($sql) {
    return super.revokeQuotation($sql);
  }
}



?  > 