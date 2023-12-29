module langs.sql.parsers.builders.unionallstatement;
import langs.sql;

@safe:

// Builder for the whole UNION ALL statement. 
class UnionAllStatementBuilder : ISqlBuilder {
  string build(Json parsedSql) {
    string mySql = "";
    auto select_builder = new SelectStatementBuilder();
    bool first = true;
    foreach (myClause; parsedSql["UNION ALL"]) {
      if (!first) {
       mySql ~= " UNION ALL ";
      } else {
        first = false;
      }

     mySql ~= select_builder.build(myClause);
    }
    return mySql;
  }
}
