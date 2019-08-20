This code zip accompanies the blog post
["Isolation levels in YugaByte DB’s YSQL"](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/). Use that post to understand the high-level philosophy for the tests that this code implements. Here is how the code is organized, and what itb does.

### Overview
To avoid repeating code, I implemented everything to do with session management and SQL processing in a common module. It looks after the following.

Session creation and termination.

Issuing, and reporting, SQL commands. (Setting the serialization level is done with a SQL command.)

Committing in the absence of error, and reporting this.

Detecting a serialization error, rolling back, and reporting this.


I want to detect a serialization error as a normal, if arguably regrettable, exception, that I handle and then let my program continue. I need to do this to make the output optimally readable. However, it would be meaningless to attempt subsequent SQL commands that my program issues, during the programmed steps of a transaction, after the transaction has suffered a serialization error. Therefore I set a flag so that I can turn such attempts into no-ops. Of course, a normal program—rather than one written as a teaching aid—would simply abort a transaction immediately on detecting a serialization error and attempt a retry.


The common module’s API has procedures to create a session and return a handle for it, to terminate a session, to commit in the specified session, to rollback in the specified session, and to execute a specified SQL text in the specified session. To keep the code simple, there is no provision for binding values to prepared statements, or for fetching and showing the results of a “select” command. Rather, because different “select” commands specify different columns with query-specific datatypes, fetching and showing the results is left to the use-case-specific module that uses the common module’s services. It can do this via the session’s handle.

There are therefore four Python source files: common.py, black_white_marbles.py, one_or_two_admins.py, and basic_tests.py. Each of the last three imports common.py.

Each use-case-specific module has command-line options to specify the isolation level (snapshot or serializable) and to specify the database (YugaByte DB or PostgreSQL) to which to connect. The latter choice allows you to confirm that each of all the tests has the semantically same outcome in both databases.
How to run the programs







The filenames are self-explanatory. Look at them first, in this order:

### common.py
This implements bla...
