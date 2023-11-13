module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterBuilder : ISqlBuilder {
    auto build(array $parsed) {    {
        auto mySql = "";

        foreach ($parsed as $term) {
            if ($term == ' ') {
                continue;
            }

            if (substr($term, 0, 1) == '(' ||
                strpos($term, "\n") !== false) {
                    mySql = rtrim(mySql);
            }

            mySql  ~= $term . ' ';
        }

        mySql = rtrim(mySql);

        return mySql;
    }
}
