module langs.sql.sqlparsers.processors.union;

import lang.sql;

@safe:
// This class processes the UNION statements.
class UnionProcessor : AbstractProcessor {

    protected auto processDefault(myToken) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process(myToken);
    }

    protected auto processSQL(myToken) {
        auto myProcessor = new SQLProcessor(this.options);
        return myProcessor.process(myToken);
    }

    static auto isUnion(queries) {
        string[] unionTypes = ["UNION", "UNION ALL"];
        foreach (myUnionType; unionTypes) {
            if (!queries[myUnionType].isEmpty)) {
                return true;
            }
        }
        return false;
    }

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
    protected auto processMySQLUnion(queries) {
        $unionTypes = ["UNION", "UNION ALL"];
        foreach (myUnionType; $unionTypes) {

            if (queries[myUnionType].isEmpty) {
                continue;
            }

            auto myUnionTypeQuery = queries[myUnionType];
            foreach (myKey, $tokenList; myUnionTypeQuery) {
                foreach ($z, myToken; $tokenList) {
                    myToken = myToken.strip;
                    if (myToken.isEmpty) {
                        continue;
                    }

                    // starts with "(select"
                    if (preg_match("/^\\(\\s*select\\s*/i", myToken)) {
                        myUnionTypeQuery[myKey] = this.processDefault(
                            this.removeParenthesisFromStart(myToken));
                        break;
                    }
                    myUnionTypeQuery[myKey] = this.processSQL(
                        myUnionTypeQuery[myKey]);
                    break;
                }
            }
        }

        // it can be parsed or not
        return queries;
    }

    /**
     * Moves the final union query into a separate output, so the remainder (such as ORDER BY) can
     * be processed separately.
     */
    protected auto splitUnionRemainder(
        queries, isUnionType, resultputArray) {
        $finalQuery = []; //If this token contains a matching pair of brackets at the start and end, use it as the final query
        $finalQueryFound = false;
        if (resultputArray.length == 1) {
            string[] tokenArray = resultputArray[0].strip.split;
            if (tokenArray[0] == "(" && tokenArray[tokenArray.length - 1] == ")") {
                queries[isUnionType][] = resultputArray;
                $finalQueryFound = true;
            }
        }

        if (!$finalQueryFound) {
            foreach (myKey, myToken; resultputArray) {
                if (myToken.toUpper == "ORDER") {
                    break;
                } else {
                    $finalQuery[] = myToken;
                    unset(resultputArray[myKey]);
                }
            }
        }

        $finalQueryString = implode($finalQuery).strip;

        if (!$finalQuery.isEmpty && $finalQueryString != "") {
            queries[isUnionType][] = $finalQuery;
        }

        $defaultProcessor = new DefaultProcessor(
            this.options);
        string rePrepareSqlString = implode(resultputArray).strip;
        if (!rePrepareSqlString.isEmpty) {
            $remainingQueries = $defaultProcessor.process(
                rePrepareSqlString);
            queries[] = $remainingQueries;
        }

        return queries;
    }

    auto process($inputArray) {
        auto resultputArray = []; // ometimes the parser needs to skip ahead until a particular
        // oken is found
        bool isSkipUntilToken = false;

        // his is the last type of union used (UNION or UNION ALL)
        // ndicates a) presence of at least one union in this query
        // b) the type of union if this is the first or last query
        bool isUnionType = false; // ometimes a "query" consists of more than one query (like a UNION query)
        // his array holds all the queries
        auto queries = [];
        foreach (myKey, myToken; $inputArray) {
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
                resultputArray[] = myToken; // here we get empty tokens, if we remove these, we get problems in parse_sql()
                continue;
            }

            isUnionType = "UNION";

            // we are looking for an ALL token right after UNION
            for ($i = myKey + 1; $i < count($inputArray); ++$i) {
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
            queries[isUnionType][] = resultputArray;
            resultputArray = [];
        }

        // the query tokens after the last UNION or UNION ALL
        // or we don"t have an UNION/UNION ALL
        if (!resultputArray.isEmpty) {
            if (isUnionType) {
                queries = this.splitUnionRemainder(queries, isUnionType, resultputArray);
            } else {
                queries[] = resultputArray;
            }
        }

        return this.processMySQLUnion(queries);
    }
}
