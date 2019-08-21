This code zip accompanies the blog post
["Isolation levels in YugaByte DB’s YSQL"](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/). Use that post to understand the high-level philosophy for the tests that this code implements. Unzip `isolation-levels.zip` on any convenient directory. But do make sure that you can invoke `ysqlsh` when this is your working directory. I found it convenient you create a sybolic link on 
["Isolation levels in YugaByte DB’s YSQL"](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/). Use that post to understand the high-level philosophy for the tests that this code implements. Unzip `isolation-levels.zip` on any convenient directory. But do make sure that you can invoke `ysqlsh` when this is your working directory. I found it convenient you create a sybolic link on `/usr/local/bin/ysql` to the shipped program here:
```
/usr/local/yugabyte-1.3.1.0/bin/ysqlsh
```
I did the same for `yb-ctl`

Enjoy! [bryn@yugabyte.com](mailto:bryn@yugabyte.com)

# The Python programs

## How the code is organized
To avoid repeating code, I implemented everything to do with session management and SQL processing in a single module, `common.py`. It looks after the following.

* Session creation and termination.

* Issuing, and reporting, SQL commands. (Setting the serialization level is done with a SQL command.)

* Committing in the absence of error, and reporting this.

* Detecting a serialization error, rolling back, and reporting this.

I want to detect a serialization error as a normal, if arguably regrettable, exception, that I handle and then let my program continue. I need to do this to make the output optimally readable. However, it would be meaningless to attempt subsequent SQL commands that my program issues, during the programmed steps of a transaction, after the transaction has suffered a serialization error. Therefore I set a flag so that I can turn such attempts into no-ops. Of course, a normal program—rather than one written as a teaching aid—would simply abort a transaction immediately on detecting a serialization error and attempt a retry.

The common module’s API has procedures to create a session and return a handle for it, to terminate a session, to commit in the specified session, to rollback in the specified session, and to execute a specified SQL text in the specified session. To keep the code simple, there is no provision for binding values to prepared statements, or for fetching and showing the results of a “select” command. Rather, because different “select” commands specify different columns with query-specific datatypes, fetching and showing the results is left to the use-case-specific module that uses the common module’s services. It can do this via the session’s handle.

There are therefore three Python source files that include `common.py`: `black_white_marbles.py`, `one_or_two_admins.py`, and `basic_tests.py`.

Each use-case-specific module has command-line options to specify the isolation level (snapshot or serializable) and to specify the database (YugaByte DB or PostgreSQL) to which to connect. The latter choice allows you to confirm that each of all the tests has the semantically same outcome in both databases.

## How to run the programs

I did all my tesing on my MacBook using macOS Mojave Version 10.14.6. And I used YugaByte DB Version 1.3.1. Don't use an earlier version! If you don't yet have this version, please follow these steps in the
[Quick Start guide](https://docs.yugabyte.com/latest/quick-start/install/).

Some experience of writing and running Python programs will help you, but you have to understand very little just to run my programs. I used I used Python 3 to develop and to test my programs. Check which version you have thus:
```
python --version
```
My programs *should* work with Python 2—but I didn't test this.

I used the
[PyCharm Python IDE (Community Edition)](https://www.jetbrains.com/pycharm/download/#section=mac)
to write my code. You might have your favorite IDE. I do recommend an IDE over `vi` or similar. A code-folding feature makes it hugely easier to navigate and to understand your code—and especially to study someone else's code.

### Install the argparse module

Install the argparse module using the following command.
```
pip install argparse
```
Run this either at the o/s prompt or at the prompt of your virtual Python environment, if that's the way you work.

### Install the psycopg2 driver

Install the python PostgreSQL driver using the following command. You can get further details for the driver [here](https://pypi.org/project/psycopg2/). Notice that it says "Psycopg 2 is both Unicode and Python 3 friendly." 
```
pip install psycopg2-binary
```
### Sanity check

Notice the file `run_all.sh`. Either `cat` it or open it in your favorite text editor. Here's what it contains:
```
# ------------------------------------------------------------------------------------------
# The "black/white marbles" scenario
# ----------------------------------
python black_white_marbles.py --db=yb --lvl=snp > black_white_marbles_output/yb_snp.txt
python black_white_marbles.py --db=yb --lvl=srl > black_white_marbles_output/yb_srl.txt
python black_white_marbles.py --db=pg --lvl=snp > black_white_marbles_output/pg_snp.txt
python black_white_marbles.py --db=pg --lvl=srl > black_white_marbles_output/pg_srl.txt


# ------------------------------------------------------------------------------------------
# The "one or two admins" scenario
# --------------------------------
python one_or_two_admins.py --db=yb --lvl=snp > one_or_two_admins_output/yb_snp.txt
python one_or_two_admins.py --db=yb --lvl=srl > one_or_two_admins_output/yb_srl.txt
python one_or_two_admins.py --db=pg --lvl=snp > one_or_two_admins_output/pg_snp.txt
python one_or_two_admins.py --db=pg --lvl=srl > one_or_two_admins_output/pg_srl.txt


# ------------------------------------------------------------------------------------------
# The basic tests
# ---------------
python basic_tests.py --db=yb --lvl=snp --c_unq=n > basic_tests_output/yb_snp_no_c_unq.txt
python basic_tests.py --db=yb --lvl=srl --c_unq=n > basic_tests_output/yb_srl_no_c_unq.txt
python basic_tests.py --db=pg --lvl=snp --c_unq=n > basic_tests_output/pg_snp_no_c_unq.txt
python basic_tests.py --db=pg --lvl=srl --c_unq=n > basic_tests_output/pg_srl_no_c_unq.txt

python basic_tests.py --db=yb --lvl=snp --c_unq=y > basic_tests_output/yb_snp_c_unq.txt
python basic_tests.py --db=yb --lvl=srl --c_unq=y > basic_tests_output/yb_srl_c_unq.txt
python basic_tests.py --db=pg --lvl=snp --c_unq=y > basic_tests_output/pg_snp_c_unq.txt
python basic_tests.py --db=pg --lvl=srl --c_unq=y > basic_tests_output/pg_srl_c_unq.txt
```
This will exercise every combination of the degrees of freedom that each of my tests supports. You can see where it writes its output. Notice that I've provided rerference copies of the output on subdirectories of these directories. Run it with the following command:
```
source run_all.sh
```
You should find that, with one caveat, each file that you generate will be identical to its supplied reference counterpart. The caveat (as my blog post explains) is that when you get a serialization error using YugaByte DB, the point at which it occurs (in which session and at which SQL command) is chosen randomly. Expect diffs the `yb_srl` variants—but understand that they have no semantic significance.

## About `AUTOCOMMIT`

Need to explain why I chose to set `AUTOCOMMIT` to `On` — and about the general principle always to invoke the `start transaction` command explicitly.

# The tests done at the `ysqlsh` prompt

*To_do*
