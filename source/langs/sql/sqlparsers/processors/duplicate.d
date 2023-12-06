module langs.sql.sqlparsers.processors.duplicate;

// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    Json process(mytokens, bool isUpdate = false) {
        return super.process(mytokens, isUpdate);
    }

}
