**SQL Indexes** are special lookup tables that are used to speed up the process of data retrieval.

They hold pointers that refer to the data stored in a database, which makes it easier to locate the required data records in a database table.

While an index speeds up the performance of data retrieval queries (SELECT statement), it slows down the performance of data input queries (UPDATE and INSERT statements). However, these indexes do not have any effect on the data.

SQL Indexes need their own storage space within the database. Despite that, the users cannot view them physically as they are just performance tools.
