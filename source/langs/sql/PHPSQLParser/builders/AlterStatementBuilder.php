
module lang.sql.parsers.builders;

class AlterStatementBuilder : IBuilder {
    protected auto buildSubTree($parsed) {
        $builder = new SubTreeBuilder();
        return $builder.build($parsed);
    }

    private auto buildAlter($parsed) {
        $builder = new AlterBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $alter = $parsed["ALTER"];
        $sql = this.buildAlter($alter);

        return $sql;
    }
}
