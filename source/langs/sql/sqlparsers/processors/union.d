module langs.sql.sqlparsers.processors.union;

import lang.sql;

@safe:
/**
 * This file : the processor for the UNION statements.
 * This class processes the UNION statements.
 */
class UnionProcessor : AbstractProcessor {

    protected auto processDefault(myToken) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor$processor.process(myToken];}

        protected auto processSQL(myToken) {
            auto myProcessor = new SQLProcessor(this.options); return myProcessor.process(myToken];
        }

        static auto isUnion($queries) {
            $unionTypes = ["UNION", "UNION ALL"]; foreach (myUnionType; $unionTypes) {
                if (!empty($queries[myUnionType])) {
                    return true;}
                }
                return false;}

                /**
     * MySQL supports a special form of UNION:
     * (select ...)
     * union
     * (select ...)
     *
     * This auto handles this query syntax. Only one such subquery
     * is supported in each UNION block. (select)(select)union(select) is not legal.
     * The extra queries will be silently ignored.
     */
                protected auto processMySQLUnion($queries) {
                    $unionTypes = ["UNION", "UNION ALL"]; foreach (myUnionType; $unionTypes) {

                        if (empty($queries[myUnionType])) {
                            continue;}

                            foreach (myKey, $tokenList; $queries[myUnionType]) {
                                foreach ($z, myToken; $tokenList) {
                                    myToken = myToken.strip; if (myToken.isEmpty) {
                                        continue;}

                                        // starts with "(select"
                                        if (preg_match("/^\\(\\s*select\\s*/i", myToken)) {
                                            $queries[myUnionType][myKey] = this.processDefault(
                                                this.removeParenthesisFromStart(myToken));
                                                break;}
                                                $queries[myUnionType][myKey] = this.processSQL(
                                                    $queries[myUnionType][myKey]);
                                                break;}
                                        }
                                    }

                                    // it can be parsed or not
                                    return $queries;}

                                    /**
     * Moves the final union query into a separate output, so the remainder (such as ORDER BY) can
     * be processed separately.
     */
                                    protected auto splitUnionRemainder(
                                        $queries, isUnionType, $outputArray) {
                                        $finalQuery = [];  //If this token contains a matching pair of brackets at the start and end, use it as the final query
                                        $finalQueryFound = false; if ($outputArray.length == 1) {
                                            $tokenAsArray = $outputArray[0].strip.split;
                                                if ($tokenAsArray[0] == "(" && $tokenAsArray[$tokenAsArray.length - 1] == ")") {
                                                    $queries[isUnionType][] = $outputArray;
                                                        $finalQueryFound = true;}
                                                }

                                            if (!$finalQueryFound) {
                                                foreach (myKey, myToken; $outputArray) {
                                                    if (myToken.toUpper == "ORDER") {
                                                        break;} else {
                                                            $finalQuery[] = myToken;
                                                                unset($outputArray[myKey]);
                                                        }
                                                    }
                                                }

                                                $finalQueryString = implode($finalQuery).strip;

                                                    if (!$finalQuery.isEmpty && $finalQueryString != "") {
                                                        $queries[isUnionType][] = $finalQuery;
                                                    }

                                                $defaultProcessor = new DefaultProcessor(
                                                    this.options); $rePrepareSqlString = implode(
                                                    $outputArray).strip; if (
                                                    !empty($rePrepareSqlString)) {
                                                    $remainingQueries = $defaultProcessor.process(
                                                        $rePrepareSqlString); $queries[] = $remainingQueries;
                                                }

                                                return $queries;}

                                                auto process($inputArray) {
                                                    $outputArray = [];  // ometimes the parser needs to skip ahead until a particular
                                                    // oken is found
                                                    bool isSkipUntilToken = false;

                                                        // his is the last type of union used (UNION or UNION ALL)
                                                        // ndicates a) presence of at least one union in this query
                                                        // b) the type of union if this is the first or last query
                                                        bool isUnionType = false;  // ometimes a "query" consists of more than one query (like a UNION query)
                                                        // his array holds all the queries
                                                        $queries = []; foreach (myKey, myToken;
                                                            $inputArray) {
                                                            auto strippedToken = myToken.strip;

                                                                // overread all tokens till that given token
                                                                if (isSkipUntilToken) {
                                                                    if (strippedToken.isEmpty) {
                                                                        continue; // read the next token
                                                                    }
                                                                    if (
                                                                        strippedToken.toUpper == isSkipUntilToken) {
                                                                        isSkipUntilToken = false;
                                                                            continue; // read the next token
                                                                    }
                                                                }

                                                            if (strippedToken.toUpper != "UNION") {
                                                                $outputArray[] = myToken; // here we get empty tokens, if we remove these, we get problems in parse_sql()
                                                                    continue;}

                                                                    isUnionType = "UNION";

                                                                    // we are looking for an ALL token right after UNION
                                                                    for ($i = myKey + 1;
                                                                        $i < count($inputArray);
                                                                        ++$i) {
                                                                        if (
                                                                            $inputArray[$i].strip
                                                                            .isEmpty) {
                                                                            continue;
                                                                        }
                                                                        if (
                                                                            $inputArray[$i].toUpper != "ALL") {
                                                                            break;
                                                                        }
                                                                        // the other for-loop should overread till "ALL"
                                                                        isSkipUntilToken = "ALL";
                                                                            isUnionType = "UNION ALL";
                                                                    }

                                                                // store the tokens related to the unionType
                                                                $queries[isUnionType][] = $outputArray;
                                                                    $outputArray = [];
                                                            }

                                                            // the query tokens after the last UNION or UNION ALL
                                                            // or we don"t have an UNION/UNION ALL
                                                            if (!empty($outputArray)) {
                                                                if (isUnionType) {
                                                                    $queries = this.splitUnionRemainder($queries, isUnionType, $outputArray);
                                                                } else {
                                                                    $queries[] = $outputArray;
                                                                }
                                                            }

                                                            return this.processMySQLUnion($queries);
                                                        }
                                                }
