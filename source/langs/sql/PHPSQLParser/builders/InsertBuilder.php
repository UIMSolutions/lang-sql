
/**
 * InsertBuilder.php
 *
 * Builds the [INSERT] statement part.
 *
 *
 * LICENSE:
 * Copyright (c) 2010-2014 Justin Swanhart and André Rothe
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 
 * @copyright 2010-2014 Justin Swanhart and André Rothe
 * @license   http://www.debian.org/misc/bsd.license  BSD License (3 Clause)
 * @version   SVN: $Id$
 * 
 */

module lang.sql.parsers.builders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the [INSERT] statement parts. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class InsertBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        $builder = new TableBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildSubQuery($parsed) {
        $builder = new SubQueryBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        $builder = new InsertColumnListBuilder();
        return $builder.build($parsed, 0);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildTable($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildBracketExpression($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('INSERT', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return 'INSERT ' . substr($sql, 0, -1);
    }

}
