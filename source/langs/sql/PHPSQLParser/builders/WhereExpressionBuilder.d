
/**
 * WhereExpressionBuilder.php
 *
 * Builds expressions within the WHERE part.
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
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for expressions within the WHERE part.
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *
 */
class WhereExpressionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        $builder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildInList($parsed) {
        $builder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildWhereBracketExpression($parsed) {
        $builder = new WhereBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        $builder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        $builder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      $builder = new ReservedBuilder();
      return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildWhereExpression($v);
            mySql  ~= this.buildWhereBracketExpression($v);
            mySql  ~= this.buildUserVariable($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildReserved($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('WHERE expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

}
