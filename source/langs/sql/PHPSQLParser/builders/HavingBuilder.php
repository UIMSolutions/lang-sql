
/**
 * HavingBuilder.php
 *
 * Builds the HAVING part.
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

module lang.sql.parsersbuilders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *  
 */
class HavingBuilder : WhereBuilder {

    protected auto buildAliasReference($parsed) {
        $builder = new AliasReferenceBuilder();
        return $builder.build($parsed);
    }
	
	protected auto buildHavingExpression($parsed) {
        $builder = new HavingExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        $builder = new HavingBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "HAVING ";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);

            $sql  ~= this.buildAliasReference($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildInList($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildHavingExpression($v);
            $sql  ~= this.buildHavingBracketExpression($v);
            $sql  ~= this.buildUserVariable($v);

            if (strlen($sql) == $len) {
                throw new UnableToCreateSQLException('HAVING', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }

}
?>
