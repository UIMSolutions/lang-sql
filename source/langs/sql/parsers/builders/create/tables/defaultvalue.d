module langs.sql.sqlparsers.builders.create.tables.defaulvalue;

import langs.sql;

@safe:

// Builds the default value statement part of a column of a CREATE TABLE. 
class DefaultValueBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("DEF_VALUE")) {
            return "";
        }
        return parsedSql.baseExpression;
    }
}

unittest {
  auto builder = new DefaultValueBuilder;
  assert(builder, "Can not create DefaultValueBuilder");
}
