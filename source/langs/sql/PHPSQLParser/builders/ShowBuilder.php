
/**
 * ShowBuilder.php
 *
 * Builds the SHOW statement.
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
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $delim) {
        $builder = new TableBuilder();
        return $builder.build($parsed, $delim);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildProcedure($parsed) {
        $builder = new ProcedureBuilder();
        return $builder.build($parsed);
    }

    protected auto buildDatabase($parsed) {
        $builder = new DatabaseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildEngine($parsed) {
        $builder = new EngineBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $show = $parsed["SHOW"];
        $sql = "";
        foreach ($show as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildEngine($v);
            $sql  ~= this.buildDatabase($v);
            $sql  ~= this.buildProcedure($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildTable($v, 0);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('SHOW', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }

        $sql = substr($sql, 0, -1);
        return "SHOW " . $sql;
    }
}
