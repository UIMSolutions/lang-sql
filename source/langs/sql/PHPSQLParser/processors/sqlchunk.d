
/**
 * SQLChunkProcessor.php
 *
 * This file : the processor for the SQL chunks.
 */

module source.langs.sql.PHPSQLParser.processors.sqlchunk;

/**
 * This class processes the SQL chunks.
 */
class SQLChunkProcessor : AbstractProcessor {

    protected auto moveLIKE(&$out) {
        if (!isset($out["TABLE"]["like"])) {
            return;
        }
        $out = this.array_insert_after($out, 'TABLE', array('LIKE' => $out["TABLE"]["like"]));
        unset($out["TABLE"]["like"]);
    }

    auto process($out) {
        if (!$out) {
            return false;
        }
        if (!empty($out["BRACKET"])) {
            // TODO: this field should be a global STATEMENT field within the output
            // we could add all other categories as sub_tree, it could also work with multipe UNIONs
            auto myProcessor = new BracketProcessor(this.options);
            $processedBracket = $processor.process($out["BRACKET"]);
            $remainingExpressions = $processedBracket[0]["remaining_expressions"];

            unset($processedBracket[0]["remaining_expressions"]);

            if(!empty($remainingExpressions)) {
                foreach($remainingExpressions as $key=>$expression) {
                    $processedBracket[][$key] = $expression;
                }
            }

            $out["BRACKET"] = $processedBracket;
        }
        if (!empty($out["CREATE"])) {
            auto myProcessor = new CreateProcessor(this.options);
            $out["CREATE"] = $processor.process($out["CREATE"]);
        }
        if (!empty($out["TABLE"])) {
            auto myProcessor = new TableProcessor(this.options);
            $out["TABLE"] = $processor.process($out["TABLE"]);
            this.moveLIKE($out);
        }
        if (!empty($out["INDEX"])) {
            auto myProcessor = new IndexProcessor(this.options);
            $out["INDEX"] = $processor.process($out["INDEX"]);
        }
        if (!empty($out["EXPLAIN"])) {
            auto myProcessor = new ExplainProcessor(this.options);
            $out["EXPLAIN"] = $processor.process($out["EXPLAIN"], array_keys($out));
        }
        if (!empty($out["DESCRIBE"])) {
            auto myProcessor = new DescribeProcessor(this.options);
            $out["DESCRIBE"] = $processor.process($out["DESCRIBE"], array_keys($out));
        }
        if (!empty($out["DESC"])) {
            auto myProcessor = new DescProcessor(this.options);
            $out["DESC"] = $processor.process($out["DESC"], array_keys($out));
        }
        if (!empty($out["SELECT"])) {
            auto myProcessor = new SelectProcessor(this.options);
            $out["SELECT"] = $processor.process($out["SELECT"]);
        }
        if (!empty($out["FROM"])) {
            auto myProcessor = new FromProcessor(this.options);
            $out["FROM"] = $processor.process($out["FROM"]);
        }
        if (!empty($out["USING"])) {
            auto myProcessor = new UsingProcessor(this.options);
            $out["USING"] = $processor.process($out["USING"]);
        }
        if (!empty($out["UPDATE"])) {
            auto myProcessor = new UpdateProcessor(this.options);
            $out["UPDATE"] = $processor.process($out["UPDATE"]);
        }
        if (!empty($out["GROUP"])) {
            // set empty array if we have partial SQL statement
            auto myProcessor = new GroupByProcessor(this.options);
            $out["GROUP"] = $processor.process($out["GROUP"], isset($out["SELECT"]) ? $out["SELECT"] : array());
        }
        if (!empty($out["ORDER"])) {
            // set empty array if we have partial SQL statement
            auto myProcessor = new OrderByProcessor(this.options);
            $out["ORDER"] = $processor.process($out["ORDER"], isset($out["SELECT"]) ? $out["SELECT"] : array());
        }
        if (!empty($out["LIMIT"])) {
            auto myProcessor = new LimitProcessor(this.options);
            $out["LIMIT"] = $processor.process($out["LIMIT"]);
        }
        if (!empty($out["WHERE"])) {
            auto myProcessor = new WhereProcessor(this.options);
            $out["WHERE"] = $processor.process($out["WHERE"]);
        }
        if (!empty($out["HAVING"])) {
            auto myProcessor = new HavingProcessor(this.options);
            $out["HAVING"] = $processor.process($out["HAVING"], isset($out["SELECT"]) ? $out["SELECT"] : array());
        }
        if (!empty($out["SET"])) {
            auto myProcessor = new SetProcessor(this.options);
            $out["SET"] = $processor.process($out["SET"], isset($out["UPDATE"]));
        }
        if (!empty($out["DUPLICATE"])) {
            auto myProcessor = new DuplicateProcessor(this.options);
            $out["ON DUPLICATE KEY UPDATE"] = $processor.process($out["DUPLICATE"]);
            unset($out["DUPLICATE"]);
        }
        if (!empty($out["INSERT"])) {
            auto myProcessor = new InsertProcessor(this.options);
            $out = $processor.process($out);
        }
        if (!empty($out["REPLACE"])) {
            auto myProcessor = new ReplaceProcessor(this.options);
            $out = $processor.process($out);
        }
        if (!empty($out["DELETE"])) {
            auto myProcessor = new DeleteProcessor(this.options);
            $out = $processor.process($out);
        }
        if (!empty($out["VALUES"])) {
            auto myProcessor = new ValuesProcessor(this.options);
            $out = $processor.process($out);
        }
        if (!empty($out["INTO"])) {
            auto myProcessor = new IntoProcessor(this.options);
            $out = $processor.process($out);
        }
        if (!empty($out["DROP"])) {
            auto myProcessor = new DropProcessor(this.options);
            $out["DROP"] = $processor.process($out["DROP"]);
        }
        if (!empty($out["RENAME"])) {
            auto myProcessor = new RenameProcessor(this.options);
            $out["RENAME"] = $processor.process($out["RENAME"]);
        }
        if (!empty($out["SHOW"])) {
            auto myProcessor = new ShowProcessor(this.options);
            $out["SHOW"] = $processor.process($out["SHOW"]);
        }
        if (!empty($out["OPTIONS"])) {
            auto myProcessor = new OptionsProcessor(this.options);
            $out["OPTIONS"] = $processor.process($out["OPTIONS"]);
        }
        if (!empty($out["WITH"])) {
        	auto myProcessor = new WithProcessor(this.options);
        	$out["WITH"] = $processor.process($out["WITH"]);
        }

        return $out;
    }
}
