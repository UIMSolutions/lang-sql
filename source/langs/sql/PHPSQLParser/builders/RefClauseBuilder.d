
/**
 * RefClauseBuilder.php
 *
 * Builds reference clauses within a JOIN.
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
 * This class : the references clause within a JOIN.
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *
 */
class RefClauseBuilder : ISqlBuilder {

    protected auto buildInList($parsed) {
        myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed == false) {
            return "";
        }
        mySql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildBracketExpression($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildSubQuery($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('expression ref_clause', $k, $v, 'expr_type');
            }

            mySql  ~= ' ';
        }
        return substr(mySql, 0, -1);
    }
}
