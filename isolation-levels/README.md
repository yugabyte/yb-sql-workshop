This code zip accompanies the blog post
["Isolation levels in YugaByte DB’s YSQL"](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/). Use that post to understand the high-level philosophy for the tests that this code implements. Unzip it on any convenient directory. But do make sure that you can invoke `ysqlsh` when this is your working directory.

# How the code is organized
To avoid repeating code, I implemented everything to do with session management and SQL processing in a single module, `common.py`. It looks after the following.

* Session creation and termination.

* Issuing, and reporting, SQL commands. (Setting the serialization level is done with a SQL command.)

* Committing in the absence of error, and reporting this.

* Detecting a serialization error, rolling back, and reporting this.

I want to detect a serialization error as a normal, if arguably regrettable, exception, that I handle and then let my program continue. I need to do this to make the output optimally readable. However, it would be meaningless to attempt subsequent SQL commands that my program issues, during the programmed steps of a transaction, after the transaction has suffered a serialization error. Therefore I set a flag so that I can turn such attempts into no-ops. Of course, a normal program—rather than one written as a teaching aid—would simply abort a transaction immediately on detecting a serialization error and attempt a retry.

The common module’s API has procedures to create a session and return a handle for it, to terminate a session, to commit in the specified session, to rollback in the specified session, and to execute a specified SQL text in the specified session. To keep the code simple, there is no provision for binding values to prepared statements, or for fetching and showing the results of a “select” command. Rather, because different “select” commands specify different columns with query-specific datatypes, fetching and showing the results is left to the use-case-specific module that uses the common module’s services. It can do this via the session’s handle.

There are therefore three Python source files that include `common.py`: `black_white_marbles.py`, `one_or_two_admins.py`, and `basic_tests.py`.

Each use-case-specific module has command-line options to specify the isolation level (snapshot or serializable) and to specify the database (YugaByte DB or PostgreSQL) to which to connect. The latter choice allows you to confirm that each of all the tests has the semantically same outcome in both databases.

I used the
[PyCharm Python IDE (Community Edition)](https://www.jetbrains.com/pycharm/download/#section=mac)
to write my code. You might have your favorite IDE. I do recommend an IDE over `vi` or similar. A code-folding feature makes it hugely easier to navigate and to understand your code—and especially to study someone else's code.

# How to run the programs

I did all my tesing on my MacBook using macOS Mojave Version 10.14.6. And I used YugaByte DB Version 1.3.1. Don't use an earlier version! If you don't yet have this version, please follow these steps in the
[Quick Start guide](https://docs.yugabyte.com/latest/quick-start/install/).

Some experience of writing and running Python programs will help you, but you have to understand very little just to run my programs. I used I used Python 3 to develop and to test my programs. Check which version you have thus:
```
python --version
```
My programs *should* work with Python 2—but I didn't test this.

## Install the argparse module

Install the argparse module using the following command.
```
pip install argparse
```
Run this either at the o/s prompt or at the prompt of your virtual Python environment, if that's the way you work.

## Install the psycopg2 driver

Install the python PostgreSQL driver using the following command. You can get further details for the driver [here](https://pypi.org/project/psycopg2/). Notice that it says "Psycopg 2 is both Unicode and Python 3 friendly." 
```
pip install psycopg2-binary
```

