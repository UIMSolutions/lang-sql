
/**
 * WhereBuilder.php
 *
 * Builds the WHERE part.
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
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the WHERE part.
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *
 */
class WhereBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereExpression($parsed) {
        auto myBuilder = new WhereExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereBracketExpression($parsed) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      auto myBuilder = new ReservedBuilder();
      return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "WHERE ";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);

            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildInList($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildWhereExpression($v);
            $sql  ~= this.buildWhereBracketExpression($v);
            $sql  ~= this.buildUserVariable($v);
            $sql  ~= this.buildReserved($v);
            
            if (strlen($sql) == $len) {
                throw new UnableToCreateSQLException('WHERE', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }

}
