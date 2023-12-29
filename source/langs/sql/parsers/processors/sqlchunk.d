module langs.sql.sqlparsers.processors.sqlchunk;
import langs.sql;

@safe:
// This class processes the SQL chunks.
class SQLChunkProcessor : Processor {

  protected auto moveLIKE(ref sqlOut) {
    if (!sqlOut.isSet("Table") 
      || !sqlOut["TABLE"].isSet("like")) { return; }

    sqlOut = this.array_insert_after(sqlOut, "TABLE", [
        "LIKE": sqlOut["TABLE"]["like"]
      ]);
    sqlOut["TABLE"].remove("like");
  }

  Json process(sqlOut) {
    if (!sqlOut) { return false; }

    if (!sqlOut["BRACKET"].isEmpty) {
      // TODO: this field should be a global STATEMENT field within the output
      // we could add all other categories as sub_tree, it could also work with multipe UNIONs
      auto myProcessor = new BracketProcessor(this.options);
      myprocessedBracket = myprocessor.process(sqlOut["BRACKET"]);
      myremainingExpressions = myprocessedBracket[0][
        "remaining_expressions"
      ];
      unset(myprocessedBracket[0]["remaining_expressions"]);

      if (!myremainingExpressions.isEmpty) {
        myremainingExpressions.byKeyValue(keyexp => myprocessedBracket[][keyexp.key] = keyexp.value);
      }
      sqlOut["BRACKET"] = myprocessedBracket;
    }
    if (!sqlOut["CREATE"].isEmpty) {
      auto myProcessor = new CreateProcessor(this.options);
      sqlOut["CREATE"] = myProcessor.process(sqlOut["CREATE"]);
    }
    if (!sqlOut["TABLE"].isEmpty) {
      auto myProcessor = new TableProcessor(this.options);
      sqlOut["TABLE"] = myProcessor.process(sqlOut["TABLE"]);
      this.moveLIKE(sqlOut);
    }

    sqlOut = sqlOut
      .processSqlIndex(_options)
      .processSqlExplain(_options)
      .processSqlDescribe(_options)
      .processSqlDesc(_options)
      .processSqlSelect(_options)
      .processSqlFrom(_options)
      .processSqlUsing(_options)
      .processSqlUpdate(_options)
      .processSqlGroup(_options)
      .processSqlLimit(_options)
      .processSqlWhere(_options)
      .processSqlHaving(_options)
      .processSqlSet(_options)
      .processSqlDuplicate(_options)
      .processSqlInsert(_options)
      .processSqlReplace(_options)
      .processSqlDelete(_options)
      .processSqlValues(_options)
      .processSqlInto(_options)
      .processSqlDrop(_options)
      .processSqlRename(_options)
      .processSqlShow(_options)
      .processSqlOptions(_options)
      .processSqlWith(_options);

    return sqlOut;
  }
}

protected Json processSqlIndex(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("INDEX") && !sqlOut["INDEX"].isEmpty) {
    auto myProcessor = new IndexProcessor(this.options);
    sqlOut["INDEX"] = myProcessor.process(sqlOut["INDEX"]);
  }

  return sqlOut;
}

protected Json processSqlExplain(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("EXPLAIN") && !sqlOut["EXPLAIN"].isEmpty) {
    auto myProcessor = new ExplainProcessor(this.options);
    sqlOut["EXPLAIN"] = myProcessor.process(sqlOut["EXPLAIN"], array_keys(sqlOut));
  }

  return sqlOut;
}

protected Json processSqlDescribe(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("DESCRIBE") && !sqlOut["DESCRIBE"].isEmpty) {
    auto myProcessor = new DescribeProcessor(this.options);
    sqlOut["DESCRIBE"] = myProcessor.process(sqlOut["DESCRIBE"], array_keys(sqlOut));
  }

  return sqlOut;
}

protected Json processSqlDesc(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("DESC") && !sqlOut["DESC"].isEmpty) {
    auto myProcessor = new DescProcessor(this.options);
    sqlOut["DESC"] = myProcessor.process(sqlOut["DESC"], array_keys(sqlOut));
  }

  return sqlOut;
}

protected Json processSqlSelect(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("SELECT") && !sqlOut["SELECT"].isEmpty) {
    auto myProcessor = new SelectProcessor(this.options);
    sqlOut["SELECT"] = myProcessor.process(sqlOut["SELECT"]);
  }

  return sqlOut;
}

protected Json processSqlFrom(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("FROM") && !sqlOut["FROM"].isEmpty) {
    auto myProcessor = new FromProcessor(this.options);
    sqlOut["FROM"] = myProcessor.process(sqlOut["FROM"]);
  }

  return sqlOut;
}

protected Json processSqlUsing(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("USING") && !sqlOut["USING"].isEmpty) {
    auto myProcessor = new UsingProcessor(this.options);
    sqlOut["USING"] = myProcessor.process(sqlOut["USING"]);
  }

  return sqlOut;
}

protected Json processSqlUpdate(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("UPDATE") && !sqlOut["UPDATE"].isEmpty) {
    auto myProcessor = new UpdateProcessor(this.options);
    sqlOut["UPDATE"] = myProcessor.process(sqlOut["UPDATE"]);
  }

  return sqlOut;
}

protected Json processSqlGroup(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("GROUP") && !sqlOut["GROUP"].isEmpty) {
    // set empty array if we have partial SQL statement
    auto myProcessor = new GroupByProcessor(this.options);
    sqlOut["GROUP"] = myProcessor.process(
      sqlOut["GROUP"], sqlOut.isSet("SELECT") 
        ? sqlOut["SELECT"] 
        : Json.emptyArray);
  }

  return sqlOut;
}

protected Json processSqlOrder(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("ORDER") && !sqlOut["ORDER"].isEmpty) {
    // set empty array if we have partial SQL statement
    auto myProcessor = new OrderByProcessor(this.options);
    sqlOut["ORDER"] = myProcessor.process(
      sqlOut["ORDER"], sqlOut.isSet("SELECT") 
        ? sqlOut["SELECT"] 
        : Json.emptyArray);
  }

  return sqlOut;
}

protected Json processSqlLimit(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("LIMIT") && !sqlOut["LIMIT"].isEmpty) {
    auto myProcessor = new LimitProcessor(this.options);
    sqlOut["LIMIT"] = myProcessor.process(sqlOut["LIMIT"]);
  }

  return sqlOut;
}

protected Json processSqlWhere(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("WHERE") && !sqlOut["WHERE"].isEmpty) {
    auto myProcessor = new WhereProcessor(this.options);
    sqlOut["WHERE"] = myProcessor.process(sqlOut["WHERE"]);
  }

  return sqlOut;
}

protected Json processSqlHaving(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("HAVING") && !sqlOut["HAVING"].isEmpty) {
    auto myProcessor = new HavingProcessor(this.options);
    sqlOut["HAVING"] = myProcessor.process(sqlOut["HAVING"], sqlOut.isSet("SELECT") 
      ? sqlOut["SELECT"] 
      : Json(null));
  }

  return sqlOut;
}

protected Json processSqlSet(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("SET") && !sqlOut["SET"].isEmpty) {
    auto myProcessor = new SetProcessor(this.options);
    sqlOut["SET"] = myProcessor.process(sqlOut["SET"], sqlOut.isSet("UPDATE"));
  }

  return sqlOut;
}

protected Json processSqlDuplicate(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("DUPLICATE") && !sqlOut["DUPLICATE"].isEmpty) {
    auto myProcessor = new DuplicateProcessor(this.options);
    sqlOut["ON DUPLICATE KEY UPDATE"] = myProcessor.process(sqlOut["DUPLICATE"]);
    sqlOut.unSet("DUPLICATE");
  }

  return sqlOut;
}

protected Json processSqlInsert(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("INSERT") && !sqlOut["INSERT"].isEmpty) {
    auto myProcessor = new InsertProcessor(this.options);
    sqlOut = myProcessor.process(sqlOut);
  }

  return sqlOut;
}

protected Json processSqlReplace(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("REPLACE") && !sqlOut["REPLACE"].isEmpty) {
    auto myProcessor = new ReplaceProcessor(this.options);
    sqlOut = myProcessor.process(sqlOut);
  }

  return sqlOut;
}

protected Json processSqlDelete(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("DELETE") && !sqlOut["DELETE"].isEmpty) {
    auto myProcessor = new DeleteProcessor(this.options);
    sqlOut = myProcessor.process(sqlOut);
  }

  return sqlOut;
}

protected Json processSqlValues(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("VALUES") && !sqlOut["VALUES"].isEmpty) {
    auto myProcessor = new ValuesProcessor(this.options);
    sqlOut = myProcessor.process(sqlOut);
  }

  return sqlOut;
}

protected Json processSqlInto(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("INTO") && !sqlOut["INTO"].isEmpty) {
    auto myProcessor = new IntoProcessor(someOptions);
    sqlOut = myProcessor.process(sqlOut);    
  }
  return sqlOut;
}

protected Json processSqlDrop(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("DROP") && !sqlOut["DROP"].isEmpty) {
    auto myProcessor = new DropProcessor(someOptions);
    sqlOut["DROP"] = myProcessor.process(sqlOut["DROP"]);
  }
  return sqlOut;
}

protected Json processSqlRename(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("RENAME") && !sqlOut["RENAME"].isEmpty) {
    auto myProcessor = new RenameProcessor(someOptions);
    sqlOut["RENAME"] = myProcessor.process(sqlOut["RENAME"]);
  }
  return sqlOut;
}

protected Json processSqlShow(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("SHOW") && !sqlOut["SHOW"].isEmpty) {
    auto myProcessor = new ShowProcessor(someOptions);
    sqlOut["SHOW"] = myProcessor.process(sqlOut["SHOW"]);
  }
  return sqlOut;
}

protected Json processSqlOptions(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("OPTIONS") && !sqlOut["OPTIONS"].isEmpty) {
    auto myProcessor = new OptionsProcessor(someOptions);
    sqlOut["OPTIONS"] = myProcessor.process(sqlOut["OPTIONS"]);
  }
  return sqlOut;
}

protected Json processSqlWith(Json sqlOut, Options someOptions) {
  if (sqlOut.isSet("WITH") && !sqlOut["WITH"].isEmpty) {
    auto myProcessor = new WithProcessor(someOptions);
    sqlOut["WITH"] = myProcessor.process(sqlOut["WITH"]);
  }
  return sqlOut;
}