
/**
 * OrderByBuilder.php
 *
 * Builds the ORDERBY clause.
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
use PHPSQLParser\utils\ExpressionType;

/**
 * This class : the builder for the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class OrderByBuilder : Builder {

    protected auto buildFunction($parsed) {
        $builder = new OrderByFunctionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildReserved($parsed) {
        $builder = new OrderByReservedBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColRef($parsed) {
        $builder = new OrderByColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        $builder = new OrderByAliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildExpression($parsed) {
        $builder = new OrderByExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        $builder = new OrderByBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildPosition($parsed) {
        $builder = new OrderByPositionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildAlias($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildExpression($v);
            $sql  ~= this.buildBracketExpression($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildPosition($v);
            
            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('ORDER', $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        }
        $sql = substr($sql, 0, -2);
        return "ORDER BY " . $sql;
    }
}
?>
