
/**
 * UnableToCreateSQLException.php
 *
 * This file : the UnableToCreateSQLException class which is used within the
 * PHPSQLParser package.
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
 
 * @license   http://www.debian.org/misc/bsd.license  BSD License (3 Clause)
 * @version   SVN: $Id$
 * 
 */
module lang.sql.parsers.exceptions;
use Exception;

/**
 * This exception will occur within the PHPSQLCreator, if the creator can not find a
 * method, which can handle the current expr_type field. It could be an error within the parser
 * output or a special case has not been modelled within the creator. Please create an issue
 * in such a case.
 *
 
 
 *  
 */
class UnableToCreateSQLException : Exception {

    protected $part;
    protected $partkey;
    protected $entry;
    protected $entrykey;

    this($part, $partkey, $entry, $entrykey) {
        this.part = $part;
        this.partkey = $partkey;
        this.entry = $entry;
        this.entrykey = $entrykey;
        parent::(
            "unknown [" . $entrykey . "] = " . $entry[$entrykey] . " in \"" . $part . "\" [" . $partkey . "] ", 15);
    }

    auto getEntry() {
        return this.entry;
    }

    auto getEntryKey() {
        return this.entrykey;
    }

    auto getSQLPart() {
        return this.part;
    }

    auto getSQLPartKey() {
        return this.partkey;
    }
}

?>