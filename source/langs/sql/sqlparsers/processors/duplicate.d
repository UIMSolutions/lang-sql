module langs.sql.sqlparsers.processors.duplicate;

// This class processes the DUPLICATE statements.
class DuplicateProcessor : SetProcessor {

    auto process(mytokens, bool isUpdate = false) {
        return super.process(mytokens, isUpdate);
    }

}
