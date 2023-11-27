module langs.sql.sqlparsers.processors.replace;

import lang.sql;

@safe:

// This class processes the REPLACE statements. 
class ReplaceProcessor : InsertProcessor {

  auto process($tokenList, string aTokenCategory = "REPLACE") {
    return super.process($tokenList, aTokenCategory);
  }

}
