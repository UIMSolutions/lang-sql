module langs.sql.PHPSQLParser.processors.duplicate;

// This file : the processor for the DUPLICATE statements.
// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    auto process($tokens, $isUpdate = false) {
        return super.process($tokens, $isUpdate);
    }

}