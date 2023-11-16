## The CREATE INDEX Statement

An index in SQL can be created using the **CREATE INDEX** statement. This statement allows you to name the index, to specify the table and which column or columns to index, and to indicate whether the index is in an ascending or descending order.

Preferably, an index must be created on column(s) of a large table that are frequently queried for data retrieval.

### Syntax

The basic syntax of a **CREATE INDEX** is as follows −

CREATE INDEX index_name ON table_name;

## Types of Indexes

There are various types of indexes that can be created using the CREATE INDEX statement. They are:

Unique Index

Single-Column Index

Composite Index

Implicit Index

### Unique Indexes

Unique indexes are used not only for performance, but also for data integrity. A unique index does not allow any duplicate values to be inserted into the table. It is automatically created by PRIMARY and UNIQUE constraints when they are applied on a database table, in order to prevent the user from inserting duplicate values into the indexed table column(s). The basic syntax is as follows.

CREATE UNIQUE INDEX index_name on table_name (column_name);

### Single-Column Indexes

A single-column index is created only on one table column. The syntax is as follows.

CREATE INDEX index_name ON table_name (column_name);

### Composite Indexes

A composite index is an index that can be created on two or more columns of a table. Its basic syntax is as follows.

CREATE INDEX index_name on table_name (column1, column2);

### Implicit Indexes

Implicit indexes are indexes that are automatically created by the database server when an object is created. For example, indexes are automatically created when primary key and unique constraints are created on a table in MySQL database.
