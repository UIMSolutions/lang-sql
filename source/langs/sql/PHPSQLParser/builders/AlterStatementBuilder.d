
module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterStatementBuilder : IBuilder {
    protected auto buildSubTree($parsed) {
        myBuilder = new SubTreeBuilder();
        return $builder.build($parsed);
    }

    private auto buildAlter($parsed) {
        myBuilder = new AlterBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $alter = $parsed["ALTER"];
        $sql = this.buildAlter($alter);

        return $sql;
    }
}
