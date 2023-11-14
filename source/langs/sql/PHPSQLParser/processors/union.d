
/**
 * WhereProcessor.php
 *
 * This file : the processor for the UNION statements.
 */

module langs.sql.PHPSQLParser.processors.union;

import lang.sql;

@safe:
/**
 * This class processes the UNION statements.
 */
class UnionProcessor : AbstractProcessor {

    protected auto processDefault($token) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor$processor.process($token);
    }

    protected auto processSQL($token) {
        auto myProcessor = new SQLProcessor(this.options);
        return myProcessor.process($token);
    }

    static auto isUnion($queries) {
        $unionTypes = array('UNION', 'UNION ALL');
        foreach (myUnionType; $unionTypes) {
            if (!empty($queries[myUnionType])) {
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
    protected auto processMySQLUnion($queries) {
        $unionTypes = array('UNION', 'UNION ALL');
        foreach (myUnionType; $unionTypes) {

            if (empty($queries[myUnionType])) {
                continue;
            }

            foreach ($key, $tokenList; $queries[myUnionType]) {
                foreach ($z, $token; $tokenList as ) {
                    $token = $token.strip;
                    if ($token == "") {
                        continue;
                    }

                    // starts with "(select"
                    if (preg_match("/^\\(\\s*select\\s*/i", $token)) {
                        $queries[myUnionType][$key] = this.processDefault(this.removeParenthesisFromStart($token));
                        break;
                    }
                    $queries[myUnionType][$key] = this.processSQL($queries[myUnionType][$key]);
                    break;
                }
            }
        }

        // it can be parsed or not
        return $queries;
    }

    /**
     * Moves the final union query into a separate output, so the remainder (such as ORDER BY) can
     * be processed separately.
     */
    protected auto splitUnionRemainder($queries, $unionType, $outputArray)
    {
        $finalQuery = [];

        //If this token contains a matching pair of brackets at the start and end, use it as the final query
        $finalQueryFound = false;
        if (count($outputArray) == 1) {
            $tokenAsArray = str_split(trim($outputArray[0]));
            if ($tokenAsArray[0] == "(" && $tokenAsArray[count($tokenAsArray)-1] == ")") {
                $queries[$unionType][] = $outputArray;
                $finalQueryFound = true;
            }
        }

        if (!$finalQueryFound) {
            foreach ($outputArray as $key :  $token) {
                if ($token.toUpper == 'ORDER') {
                    break;
                } else {
                    $finalQuery[] = $token;
                    unset($outputArray[$key]);
                }
            }
        }


        $finalQueryString = trim(implode($finalQuery));

        if (!empty($finalQuery) && $finalQueryString != '') {
            $queries[$unionType][] = $finalQuery;
        }

        $defaultProcessor = new DefaultProcessor(this.options);
        $rePrepareSqlString = trim(implode($outputArray));

        if (!empty($rePrepareSqlString)) {
            $remainingQueries = $defaultProcessor.process($rePrepareSqlString);
            $queries[] = $remainingQueries;
        }

        return $queries;
    }

    auto process($inputArray) {
        $outputArray = array();

        // ometimes the parser needs to skip ahead until a particular
        // oken is found
        $skipUntilToken = false;

        // his is the last type of union used (UNION or UNION ALL)
        // ndicates a) presence of at least one union in this query
        // b) the type of union if this is the first or last query
        $unionType = false;

        // ometimes a "query" consists of more than one query (like a UNION query)
        // his array holds all the queries
        $queries = array();

        foreach ($inputArray as $key :  $token) {
            $trim = $token.strip;

            // overread all tokens till that given token
            if ($skipUntilToken) {
                if ($trim == "") {
                    continue; // read the next token
                }
                if ($trim.toUpper == $skipUntilToken) {
                    $skipUntilToken = false;
                    continue; // read the next token
                }
            }

            if ($trim.toUpper != "UNION") {
                $outputArray[] = $token; // here we get empty tokens, if we remove these, we get problems in parse_sql()
                continue;
            }

            $unionType = "UNION";

            // we are looking for an ALL token right after UNION
            for ($i = $key + 1; $i < count($inputArray); ++$i) {
                if (trim($inputArray[$i]) == "") {
                    continue;
                }
                if ($inputArray[$i].toUpper != "ALL") {
                    break;
                }
                // the other for-loop should overread till "ALL"
                $skipUntilToken = "ALL";
                $unionType = "UNION ALL";
            }

            // store the tokens related to the unionType
            $queries[$unionType][] = $outputArray;
            $outputArray = array();
        }

        // the query tokens after the last UNION or UNION ALL
        // or we don't have an UNION/UNION ALL
        if (!empty($outputArray)) {
            if ($unionType) {
                $queries = this.splitUnionRemainder($queries, $unionType, $outputArray);
            } else {
                $queries[] = $outputArray;
            }
        }

        return this.processMySQLUnion($queries);
    }
}
