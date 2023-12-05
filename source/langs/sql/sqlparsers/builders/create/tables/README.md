Database tables in any RDBMS are used to store the data in the form of some structures (fields and records). Here, a **field** is a column defining the type of data to be stored in a table and **record** is a row containing actual data. SQL provides various queries to interact with the data in a convenient way. We can use SQL statements to create and delete tables, inserting, updating and deleting data in these tables.

This tutorial will teach you how to use SQL to create tables. For a more detail on different concepts related to RDBMS please check [RDBMS Concepts](https://www.tutorialspoint.com/sql/sql/sql-rdbms-concepts.htm) tutorial.

## The SQL CREATE TABLE Statement

SQL provides the **CREATE TABLE** statement to create a new table in a given database. An SQL query to create a table must define the structure of a table. The structure consists of the name of a table and names of columns in the table with each column"s data type. Note that each table must be uniquely named in a database.

### Syntax

Following is the basic syntax of a SQL CREATE TABLE statement −

CREATE TABLE table_name(  column1 datatype,   column2 datatype,   column3 datatype,   .....   columnN datatype,   PRIMARY KEY(one or more columns ) );

CREATE TABLE is the keyword telling the database system what you want to do. In this case, you want to create a new table. The unique name or identifier for the table follows the CREATE TABLE statement.

Then in brackets comes the list defining each column in the table and what sort of data type it is. The syntax becomes clearer with the following example.

### Example

The following code block is an example, which creates a CUSTOMERS table with an ID as a primary key and NOT NULL are the constraints showing that these fields cannot be NULL while creating records in this table −

CREATE TABLE CUSTOMERS(  ID          INT NOT NULL,   NAME        VARCHAR (20) NOT NULL,   AGE         INT NOT NULL,   ADDRESS     CHAR (25),   SALARY      DECIMAL (18, 2),   PRIMARY KEY (ID) );

### Verification

Once your table is created, you can check if it has been created successfully or not. You can use SQL **DESC table_name** command to list down the description of the table as follows:

DESC CUSTOMERS;

This will display the structure of the table created: column names, their respective data types, constraints (if any) etc.

| **Field** | **Type**      | **Null** | **Key** | **Default** | **Extra** |
| --------- | ------------- | -------- | ------- | ----------- | --------- |
| ID        | int(11)       | NO       | PRI     | NULL        |           |
| NAME      | varchar(20)   | NO       |         | NULL        |           |
| AGE       | int(11)       | NO       |         | NULL        |           |
| ADDRESS   | char(25)      | YES      |         | NULL        |           |
| SALARY    | decimal(18,2) | YES      |         | NULL        |           |

Now, you have CUSTOMERS table available in your database which you can use to store the required information related to customers.

## SQL CREATE TABLE IF NOT EXISTS

Consider a situation where you will try to create a table which already exists, in such situation MySQL will throw the following error.

ERROR 1050 (42S01): Table "CUSTOMERS" already exists

So to avoid such error we can use SQL command **CREATE TABLE IF NOT EXISTS** to create a table.

### Syntax

Following is the basic syntax of a CREATE TABLE IF NOT EXISTS statement −

CREATE TABLE IF NOT EXISTS table_name(  column1 datatype,   column2 datatype,   column3 datatype,   .....   columnN datatype,   PRIMARY KEY(one or more columns ) );

### Example

The following SQL command will create the **CUSTOMERS** table only when there is no table exists with the same name otherwise it will exit without any error.

CREATE TABLE IF NOT EXISTS CUSTOMERS(  ID          INT NOT NULL,   NAME        VARCHAR (20) NOT NULL,   AGE         INT NOT NULL,   ADDRESS     CHAR (25),   SALARY      DECIMAL (18, 2),   PRIMARY KEY (ID) );

## Creating a Table from an Existing Table

Instead of creating a new table every time, one can also copy an existing table and its contents including its structure, into a new table. This can be done using a combination of the CREATE TABLE statement and the SELECT statement. Since its structure is copied, the new table will have the same column definitions as the original table. Furthermore, the new table would be populated using the existing values from the old table.

### Syntax

The basic syntax for creating a table from another table is as follows −

CREATE TABLE NEW_TABLE_NAME AS SELECT \[column1, column2...columnN\] FROM EXISTING_TABLE_NAME WHERE Condition;

Here, column1, column2... are the fields of the existing table and the same would be used to create fields of the new table.

### Example

Following is an example, which would create a table SALARY using the CUSTOMERS table and having the fields customer ID and customer SALARY −

CREATE TABLE SALARY AS SELECT ID, SALARY FROM CUSTOMERS;

This will create a new table SALARY which will have the following structure −

| **Field** | **Type**      | **Null** | **Key** | **Default** | **Extra** |
| --------- | ------------- | -------- | ------- | ----------- | --------- |
| ID        | int(11)       | NO       | PRI     | NULL        |           |
| SALARY    | decimal(18,2) | YES      |         | NULL        |           |

##### **Kickstart Your Career**

Get certified by completing the course
