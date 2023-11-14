
/**
 * DuplicateProcessor.php
 *
 * This file : the processor for the DUPLICATE statements.
 */

module source.langs.sql.PHPSQLParser.processors.duplicate;

// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    auto process($tokens, $isUpdate = false) {
        return super.process($tokens, $isUpdate);
    }

}
