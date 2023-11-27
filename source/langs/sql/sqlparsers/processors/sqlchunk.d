module langs.sql.sqlparsers.processors.sqlchunk;
import lang.sql;

@safe:
// This class processes the SQL chunks.
class SQLChunkProcessor : AbstractProcessor {

    protected auto moveLIKE( & $out ) {
        if (!isset($out ["TABLE"]["like"])) {
            return;
        }

        $out  = this.array_insert_after($out , "TABLE", ["LIKE": $out ["TABLE"]["like"]));
                unset($out ["TABLE"]["like"]);
                }

                auto process($out ) {
                    if (!$out ) {
                        return false;
                    }
                    if (!$out ["BRACKET"].isEmpty) {
                        // TODO: this field should be a global STATEMENT field within the output
                        // we could add all other categories as sub_tree, it could also work with multipe UNIONs
                        auto myProcessor = new BracketProcessor(this.options);
                        $processedBracket = $processor.process($out ["BRACKET"]);
                        $remainingExpressions = $processedBracket[0]["remaining_expressions"];

                        unset($processedBracket[0]["remaining_expressions"]);

                        if (!empty($remainingExpressions)) {
                            foreach (myKey, $expression; $remainingExpressions) {
                                $processedBracket[][myKey] = $expression;
                            }
                        }

                        $out ["BRACKET"] = $processedBracket;
                    }
                    if (!$out ["CREATE"].isEmpty) {
                        auto myProcessor = new CreateProcessor(this.options);
                        $out ["CREATE"] = $processor.process($out ["CREATE"]);
                    }
                    if (!$out ["TABLE"].isEmpty) {
                        auto myProcessor = new TableProcessor(this.options);
                        $out ["TABLE"] = $processor.process($out ["TABLE"]);
                        this.moveLIKE($out );
                    }
                    if (!$out ["INDEX"].isEmpty) {
                        auto myProcessor = new IndexProcessor(this.options);
                        $out ["INDEX"] = $processor.process($out ["INDEX"]);
                    }
                    if (!$out ["EXPLAIN"].isEmpty) {
                        auto myProcessor = new ExplainProcessor(this.options);
                        $out ["EXPLAIN"] = $processor.process($out ["EXPLAIN"], array_keys($out ));
                    }
                    if (!$out ["DESCRIBE"].isEmpty) {
                        auto myProcessor = new DescribeProcessor(this.options);
                        $out ["DESCRIBE"] = $processor.process($out ["DESCRIBE"], array_keys($out ));
                    }
                    if (!$out ["DESC"].isEmpty) {
                        auto myProcessor = new DescProcessor(this.options);
                        $out ["DESC"] = $processor.process($out ["DESC"], array_keys($out ));
                    }
                    if (!$out ["SELECT"].isEmpty) {
                        auto myProcessor = new SelectProcessor(this.options);
                        $out ["SELECT"] = $processor.process($out ["SELECT"]);
                    }
                    if (!$out ["FROM"].isEmpty) {
                        auto myProcessor = new FromProcessor(this.options);
                        $out ["FROM"] = $processor.process($out ["FROM"]);
                    }
                    if (!$out ["USING"].isEmpty) {
                        auto myProcessor = new UsingProcessor(this.options);
                        $out ["USING"] = $processor.process($out ["USING"]);
                    }
                    if (!empty($out ["UPDATE"])) {
                        auto myProcessor = new UpdateProcessor(this.options);
                        $out ["UPDATE"] = $processor.process($out ["UPDATE"]);
                    }
                    if (!$out ["GROUP"].isEmpty) {
                        // set empty array if we have partial SQL statement
                        auto myProcessor = new GroupByProcessor(this.options);
                        $out ["GROUP"] = $processor.process($out ["GROUP"], $out .isSet("SELECT") ? $out ["SELECT"]
                            : []);
                    }
                    if (!$out ["ORDER"].isEmpty) {
                        // set empty array if we have partial SQL statement
                        auto myProcessor = new OrderByProcessor(this.options);
                        $out ["ORDER"] = $processor.process($out ["ORDER"], $out .isSet("SELECT") ? $out ["SELECT"]
                            : []);
                    }
                    if (!$out ["LIMIT"].isEmpty) {
                        auto myProcessor = new LimitProcessor(this.options);
                        $out ["LIMIT"] = $processor.process($out ["LIMIT"]);
                    }
                    if (!$out ["WHERE"].isEmpty) {
                        auto myProcessor = new WhereProcessor(this.options);
                        $out ["WHERE"] = $processor.process($out ["WHERE"]);
                    }
                    if (!$out ["HAVING"].isEmpty) {
                        auto myProcessor = new HavingProcessor(this.options);
                        $out ["HAVING"] = $processor.process($out ["HAVING"], $out .isSet("SELECT") ? $out ["SELECT"]
                            : []);
                    }
                    if (!$out ["SET"].isEmpty) {
                        auto myProcessor = new SetProcessor(this.options);
                        $out ["SET"] = $processor.process($out ["SET"], $out .isSet("UPDATE"));
                    }
                    if (!$out ["DUPLICATE"].isEmpty) {
                        auto myProcessor = new DuplicateProcessor(this.options);
                        $out ["ON DUPLICATE KEY UPDATE"] = $processor.process($out ["DUPLICATE"]);
                        $out .unSet("DUPLICATE");
                    }
                    if (!$out ["INSERT"].isEmpty) {
                        auto myProcessor = new InsertProcessor(this.options);
                        $out  = $processor.process($out );
                    }
                    if (!$out ["REPLACE"].isEmpty) {
                        auto myProcessor = new ReplaceProcessor(this.options);
                        $out  = $processor.process($out );
                    }
                    if (!$out ["DELETE"].isEmpty) {
                        auto myProcessor = new DeleteProcessor(this.options);
                        $out  = $processor.process($out );
                    }
                    if (!$out ["VALUES"].isEmpty) {
                        auto myProcessor = new ValuesProcessor(this.options);
                        $out  = $processor.process($out );
                    }
                    if (!$out ["INTO"].isEmpty) {
                        auto myProcessor = new IntoProcessor(this.options);
                        $out  = $processor.process($out );
                    }
                    if (!$out ["DROP"].isEmpty) {
                        auto myProcessor = new DropProcessor(this.options);
                        $out ["DROP"] = $processor.process($out ["DROP"]);
                    }
                    if (!$out ["RENAME"].isEmpty) {
                        auto myProcessor = new RenameProcessor(this.options);
                        $out ["RENAME"] = $processor.process($out ["RENAME"]);
                    }
                    if (!$out ["SHOW"].isEmpty) {
                        auto myProcessor = new ShowProcessor(this.options);
                        $out ["SHOW"] = $processor.process($out ["SHOW"]);
                    }
                    if (!$out ["OPTIONS"].isEmpty) {
                        auto myProcessor = new OptionsProcessor(this.options);
                        $out ["OPTIONS"] = $processor.process($out ["OPTIONS"]);
                    }
                    if (!$out ["WITH"].isEmpty) {
                        auto myProcessor = new WithProcessor(this.options);
                        $out ["WITH"] = $processor.process($out ["WITH"]);
                    }

                    return $out ;
                }
                }
