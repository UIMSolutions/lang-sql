module langs.sql.PHPSQLParser.processors.replace;

import lang.sql;

@safe:

// This file : the processor for the REPLACE statements. 
// This class processes the REPLACE statements. 
class ReplaceProcessor : InsertProcessor {

    auto process($tokenList, $token_category = "REPLACE") {
        return super.process($tokenList, $token_category);
    }

}
