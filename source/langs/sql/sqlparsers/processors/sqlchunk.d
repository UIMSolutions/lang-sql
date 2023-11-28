module langs.sql.sqlparsers.processors.sqlchunk;
import lang.sql;

@safe:
// This class processes the SQL chunks.
class SQLChunkProcessor : AbstractProcessor {

  protected auto moveLIKE(ref sqlOut) {
    if (!isSet(sqlOut["TABLE"]["like"])) {
      return;
    }

    sqlOut = this.array_insert_after(sqlOut, "TABLE", [
        "LIKE": sqlOut["TABLE"]["like"]
      ]);
    unset(sqlOut["TABLE"]["like"]);
  }

  auto process(sqlOut) {
    if (!sqlOut) {
      return false;
    }
    if (!sqlOut["BRACKET"].isEmpty) {
      // TODO: this field should be a global STATEMENT field within the output
      // we could add all other categories as sub_tree, it could also work with multipe UNIONs
      auto myProcessor = new BracketProcessor(this.options);
       myprocessedBracket =  myprocessor.process(sqlOut["BRACKET"]);
       myremainingExpressions =  myprocessedBracket[0][
        "remaining_expressions"
      ];
      unset( myprocessedBracket[0]["remaining_expressions"]);

      if (!empty( myremainingExpressions)) {
        foreach (myKey,  myexpression;  myremainingExpressions) {
           myprocessedBracket[][myKey] =  myexpression;
        }
      }

      sqlOut["BRACKET"] =  myprocessedBracket;
    }
    if (!sqlOut["CREATE"].isEmpty) {
      auto myProcessor = new CreateProcessor(this.options);
      sqlOut["CREATE"] = myProcessor.process(
        sqlOut["CREATE"]);
    }
    if (!sqlOut["TABLE"].isEmpty) {
      auto myProcessor = new TableProcessor(this.options);
      sqlOut["TABLE"] = myProcessor.process(
        sqlOut["TABLE"]);
      this.moveLIKE(sqlOut);
    }
    if (!sqlOut["INDEX"].isEmpty) {
      auto myProcessor = new IndexProcessor(this.options);
      sqlOut["INDEX"] = myProcessor.process(
        sqlOut["INDEX"]);
    }
    if (!sqlOut["EXPLAIN"].isEmpty) {
      auto myProcessor = new ExplainProcessor(
        this.options);
      sqlOut["EXPLAIN"] = myProcessor.process(
        sqlOut["EXPLAIN"], array_keys(sqlOut));
    }
    if (!sqlOut["DESCRIBE"].isEmpty) {
      auto myProcessor = new DescribeProcessor(
        this.options);
      sqlOut["DESCRIBE"] = myProcessor.process(
        sqlOut["DESCRIBE"], array_keys(sqlOut));
    }
    if (!sqlOut["DESC"].isEmpty) {
      auto myProcessor = new DescProcessor(this.options);
      sqlOut["DESC"] = myProcessor.process(sqlOut["DESC"], array_keys(
          sqlOut));
    }
    if (!sqlOut["SELECT"].isEmpty) {
      auto myProcessor = new SelectProcessor(
        this.options);
      sqlOut["SELECT"] = myProcessor.process(
        sqlOut["SELECT"]);
    }
    if (!sqlOut["FROM"].isEmpty) {
      auto myProcessor = new FromProcessor(
        this.options);
      sqlOut["FROM"] = myProcessor.process(
        sqlOut["FROM"]);
    }
    if (!sqlOut["USING"].isEmpty) {
      auto myProcessor = new UsingProcessor(
        this.options);
      sqlOut["USING"] = myProcessor.process(
        sqlOut["USING"]);
    }
    if (!empty(sqlOut["UPDATE"])) {
      auto myProcessor = new UpdateProcessor(
        this.options);
      sqlOut["UPDATE"] = myProcessor.process(
        sqlOut["UPDATE"]);
    }
    if (!sqlOut["GROUP"].isEmpty) {
      // set empty array if we have partial SQL statement
      auto myProcessor = new GroupByProcessor(
        this.options);
      sqlOut["GROUP"] = myProcessor.process(
        sqlOut["GROUP"], sqlOut.isSet("SELECT") ? sqlOut["SELECT"] : [
        ]);
    }
    if (!sqlOut["ORDER"].isEmpty) {
      // set empty array if we have partial SQL statement
      auto myProcessor = new OrderByProcessor(
        this.options);
      sqlOut["ORDER"] = myProcessor.process(
        sqlOut["ORDER"], sqlOut.isSet("SELECT") ? sqlOut["SELECT"] : [
        ]);
    }
    if (!sqlOut["LIMIT"].isEmpty) {
      auto myProcessor = new LimitProcessor(
        this.options);
      sqlOut["LIMIT"] = myProcessor.process(
        sqlOut["LIMIT"]);
    }
    if (!sqlOut["WHERE"].isEmpty) {
      auto myProcessor = new WhereProcessor(
        this.options);
      sqlOut["WHERE"] = myProcessor.process(
        sqlOut["WHERE"]);
    }
    if (!sqlOut["HAVING"].isEmpty) {
      auto myProcessor = new HavingProcessor(
        this.options);
      sqlOut["HAVING"] = myProcessor.process(
        sqlOut["HAVING"], sqlOut.isSet("SELECT") ? sqlOut["SELECT"] : [
        ]);
    }
    if (!sqlOut["SET"].isEmpty) {
      auto myProcessor = new SetProcessor(
        this.options);
      sqlOut["SET"] = myProcessor.process(
        sqlOut["SET"], sqlOut.isSet(
          "UPDATE"));
    }
    if (
      !sqlOut["DUPLICATE"]
      .isEmpty) {
      auto myProcessor = new DuplicateProcessor(
        this.options);
      sqlOut["ON DUPLICATE KEY UPDATE"] = myProcessor
        .process(
          sqlOut["DUPLICATE"]);
      sqlOut.unSet(
        "DUPLICATE");
    }
    if (!sqlOut["INSERT"].isEmpty) {
      auto myProcessor = new InsertProcessor(
        this.options);
      sqlOut = myProcessor.process(
        sqlOut);
    }
    if (!sqlOut["REPLACE"].isEmpty) {
      auto myProcessor = new ReplaceProcessor(
        this.options);
      sqlOut = myProcessor.process(
        sqlOut);
    }
    if (!sqlOut["DELETE"].isEmpty) {
      auto myProcessor = new DeleteProcessor(
        this.options);
      sqlOut = myProcessor.process(
        sqlOut);
    }
    if (!sqlOut["VALUES"].isEmpty) {
      auto myProcessor = new ValuesProcessor(
        this.options);
      sqlOut = myProcessor.process(
        sqlOut);
    }
    if (!sqlOut["INTO"].isEmpty) {
      auto myProcessor = new IntoProcessor(
        this.options);
      sqlOut = myProcessor.process(
        sqlOut);
    }
    if (!sqlOut["DROP"].isEmpty) {
      auto myProcessor = new DropProcessor(
        this.options);
      sqlOut["DROP"] = myProcessor.process(
        sqlOut["DROP"]);
    }
    if (!sqlOut["RENAME"].isEmpty) {
      auto myProcessor = new RenameProcessor(
        this.options);
      sqlOut["RENAME"] = myProcessor.process(
        sqlOut["RENAME"]);
    }
    if (!sqlOut["SHOW"].isEmpty) {
      auto myProcessor = new ShowProcessor(
        this.options);
      sqlOut["SHOW"] = myProcessor.process(
        sqlOut["SHOW"]);
    }
    if (!sqlOut["OPTIONS"].isEmpty) {
      auto myProcessor = new OptionsProcessor(
        this.options);
      sqlOut["OPTIONS"] = myProcessor.process(
        sqlOut["OPTIONS"]);
    }
    if (!sqlOut["WITH"].isEmpty) {
      auto myProcessor = new WithProcessor(
        this.options);
      sqlOut["WITH"] = myProcessor.process(
        sqlOut["WITH"]);
    }

    return sqlOut;
  }
}
