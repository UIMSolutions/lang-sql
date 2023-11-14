
/**
 * DuplicateProcessor.php
 *
 * This file : the processor for the DUPLICATE statements.
 */

module lang.sql.parsers.processors;

/**
 * 
 * This class processes the DUPLICATE statements.
 * 
 * @author arothe */
class DuplicateProcessor : SetProcessor {

    auto process($tokens, $isUpdate = false) {
        return super.process($tokens, $isUpdate);
    }

}
