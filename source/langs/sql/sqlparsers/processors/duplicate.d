module langs.sql.sqlparsers.processors.duplicate;

// This file : the processor for the DUPLICATE statements.
// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    auto process($tokens, bool isUpdate = false) {
        return super.process($tokens, isUpdate);
    }

}
