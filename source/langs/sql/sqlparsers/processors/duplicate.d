module langs.sql.sqlparsers.processors.duplicate;

// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    auto process($tokens, bool isUpdate = false) {
        return super.process($tokens, isUpdate);
    }

}
