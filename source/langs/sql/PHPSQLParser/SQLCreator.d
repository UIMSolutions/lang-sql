module langs.sql.PHPSQLParser.SQLCreator;

/**
 * PHPSQLCreator.php
 *
 * A creator, which generates SQL from the output of SqlParser.
 *
 *
 * LICENSE:
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
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS"" AND ANY EXPRESS OR
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
 
 * @license   http://www.debian.org/misc/bsd.license  BSD License (3 Clause)
 * @version   SVN: $Id$ */

namespace SqlParser;

import lang.sql;

@safe:;

// This class generates SQL from the output of the SqlParser. 
class PHPSQLCreator {

    $created;

    this($parsed = false) {
        if ($parsed) {
            this.create($parsed);
        }
    }

    auto create($parsed) {
        $k = key($parsed);
        switch ($k) {

        case 'UNION':
			auto myBuilder = new UnionStatementBuilder();
			this.created = myBuilder.build($parsed);
			break;
        case 'UNION ALL':
            auto myBuilder = new UnionAllStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'SELECT':
            auto myBuilder = new SelectStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'INSERT':
            auto myBuilder = new InsertStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'REPLACE':
            auto myBuilder = new ReplaceStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'DELETE':
            auto myBuilder = new DeleteStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'TRUNCATE':
            auto myBuilder = new TruncateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'UPDATE':
            auto myBuilder = new UpdateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'RENAME':
            auto myBuilder = new RenameStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'SHOW':
            auto myBuilder = new ShowStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'CREATE':
            auto myBuilder = new CreateStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'BRACKET':
            auto myBuilder = new BracketStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'DROP':
            auto myBuilder = new DropStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        case 'ALTER':
            auto myBuilder = new AlterStatementBuilder();
            this.created = myBuilder.build($parsed);
            break;
        default:
            throw new UnsupportedFeatureException($k);
            break;
        }
        return this.created;
    }
}
