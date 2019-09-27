**NOTE: This needs to be updated. I made several changes since I wrote it.**

This code zip accompanies the three-part blog post *"Distributed SQL Transaction Isolation
in YugaByte DB"*, here:

* [Part One](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/)
* [Part Two](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/)
* [Part Three](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/)

Use that post to understand the high-level philosophy for the tests that this code implements. Unzip `isolation-levels.zip` on any convenient directory. But do make sure that you can invoke `ysqlsh` when this is your working directory. I use using macOS Mojave and found it convenient to create a symbolic link on `/usr/local/bin/ysql` to the shipped program here:
```
/usr/local/yugabyte-1.2.0.0/bin/ysqlsh
```
I did the same for `yb-ctl`. You can do something similar in whatever environment you use.

Enjoy! [bryn@yugabyte.com](mailto:bryn@yugabyte.com)

# The Python programs

## How the code is organized

To avoid repeating code, I implemented everything to do with session management and SQL processing in a single module, `cmn.py`. It looks after the following.

* Session creation and termination.

* Executing SQL statements—printing, for each execution, an informal plain English version translation. (Setting the serialization level is done by executing a SQL statement.)

* Committing in the absence of error, and reporting this.

* Detecting a serialization error, rolling back, and reporting this.

I want to detect a serialization error as a normal, if arguably regrettable, exception, that I handle and then let my program continue. I need to do this to make the output optimally readable. However, it would be meaningless to attempt to execute any of the subsequent SQL statements that implement the programmed steps of a transaction after any one statement execution has suffered a serialization error. Therefore I set a flag so that I can turn such attempts into no-ops. Of course, a normal program, rather than one written as a teaching aid, would simply abort a transaction immediately on detecting a serialization error and attempt a retry.

The common module’s API has procedures to create a session and return a handle for it, to terminate a session, to commit in the specified session, to rollback in the specified session, and to execute a specified SQL text in the specified session. It also wraps this behind an API that creates two sessions that will interleave the esecution of the individual SQL statements that implement multi-statement transactions.

To keep the code simple, there is no provision for binding values to prepared statements, or for fetching and showing the results of executing a “select” statement. Rather, because different “select” statements specify different columns with query-specific datatypes, fetching and showing the results is left to the use-case-specific module that uses the common module’s services. It can do this via the session’s handle.

There are therefore four Python source files that import `cmn.py`: `black_white_marbles.py`, `one_or_two_admins.py`,  `basic_tests.py`, and `retry_loop.py`. Again to avoid repeating code, and because both `one_or_two_admins.py` and `retry_loop.py` use the same "one or two Admins" scenario, these two modules import `admins_cmn.py`. This implements the SQL statements and common operations that these two modules rely on.

Each use-case-specific module has command-line arguments to specify the transaction isolation level (snapshot or serializable) and to specify the database (YugaByte DB or PostgreSQL) to which to connect. The latter choice allows you to confirm that each of all the tests has the semantically same outcome in both databases. Some of the modules have further use-case-specific command-line arguments.

## How to run the programs

I did all my testing on my MacBook using macOS Mojave Version 10.14.6. And I used YugaByte DB Version 1.2.0. Don't use an earlier version! If you don't yet have this version, please follow these steps in the
[Quick Start guide](https://docs.yugabyte.com/latest/quick-start/install/).

Some experience of writing and running Python programs will help you, but you have to understand very little just to run my programs. I used Python 3 to develop and to test my programs. Check which version you have thus:
```
python --version
```
My programs *should* work with Python 2—but I didn't test this.

I used the
[PyCharm Python IDE](https://www.jetbrains.com/pycharm/download/#section=mac)
(Community Edition) to write my code. You might have your favorite IDE. I do recommend an IDE over `vi` or similar. A code-folding feature makes it hugely easier to navigate and to understand your code—and especially to study someone else's code.

### Install the argparse module

Install the `argparse` module using the following command.
```
pip install argparse
```
Run this either at the o/s prompt or at the prompt of your virtual Python environment, if that's the way you work.

### Install the psycopg2 driver

Install the python PostgreSQL driver using the following command. You can get further details for the driver [here](https://pypi.org/project/psycopg2/). Notice that it says "Psycopg 2 is... Python 3 friendly." 
```
pip install psycopg2-binary
```
### Sanity check

Notice the file `run_all.sh`. Either `cat` it or open it in your favorite text editor. Here's an sample of what it contains:
```
# ------------------------------------------------------------------------------------------
# The "black/white marbles" scenario
# ----------------------------------
python black_white_marbles.py --db=yb --lvl=srl > black_white_marbles_output/yb_srl.txt
python black_white_marbles.py --db=yb --lvl=snp > black_white_marbles_output/yb_snp.txt
python black_white_marbles.py --db=pg --lvl=srl > black_white_marbles_output/pg_srl.txt
python black_white_marbles.py --db=pg --lvl=snp > black_white_marbles_output/pg_snp.txt

# ------------------------------------------------------------------------------------------
# The "one or two admins" scenario
# --------------------------------
python one_or_two_admins.py --db=yb --lvl=srl > one_or_two_admins_output/yb_srl.txt
python one_or_two_admins.py --db=yb --lvl=snp > one_or_two_admins_output/yb_snp.txt
python one_or_two_admins.py --db=pg --lvl=srl > one_or_two_admins_output/pg_srl.txt
python one_or_two_admins.py --db=pg --lvl=snp > one_or_two_admins_output/pg_snp.txt

# ------------------------------------------------------------------------------------------
```
It has corresponding entries for `basic_tests.py`. Its commands will exercise every combination of the degrees of freedom that each of my tests supports. You can see where it writes its output. Notice that I've provided read-only reference copies of the output on subdirectories of these directories. Run it with the following command:
```
source run_all.sh
```
You should find that, with one caveat, each file that you generate will be identical to its supplied reference counterpart. The caveat (as my blog post explains) is that when you get a serialization error using YugaByte DB, the point at which it occurs (in which session and at which SQL statement execution) is chosen randomly. Expect diffs for the `yb_srl` variants—but understand that they have no semantic significance.

I've also provided and retry_loop_manual_commands.sh to run `retry_loop.py`. Don't simply execute this mechanically. rather, you must copy-and-paste the command with `--mode=setup_two_admins` or `--mode=setup_one_admin` according to whuch test you'll run. Then you must edit the commmands to start the two concurrent sessions to edit `--start_at="<yyyy-mm-dd hh24:mi:ss>"` to set a start time shorly after when you'll be able to start the two concurrent program invocations. I explain the purpose of this in the bg post.

## About AUTOCOMMIT

PostgreSQL, and therefore YugaByte DB, have a server-side `On/Off` feature called `AUTOCOMMIT`. The default setting for this is `On`. And it means what it says. With this setting, the server automatically starts a transaction before every new ordinary SQL statement that it receives and it executes a `commit` immediately after this client-submitted SQL statement finishes. (The `commit` has the same effect as `rollback` following a SQL statement execution that causes an error.) The `On` default setting helps *ad hoc* work at the `ysqlsh` prompt, especially when you type a semantic error—or even a syntax error. If you do this during an ongoing transaction, then the transaction is left in a broken state and the attempt to execute any subsequent SQL statement causes an error that says that it won't have any effect until you issue `commit` or `rollback`.

With `AUTOCOMMIT` set to `On`, you simply execute the `start transaction` statement explicitly, specifying the desired isolation level, just as you would if it were set to `Off`, when you want to execute a multi-statement transaction. Having done this, you own the responsibility to issue `commit` or `rollback` to finish the transaction; the server won't do this for you.

I decided always to set `AUTOCOMMIT` to `On` for all my tests. (`psycopg2` has a procedure for setting this.) The only "penalty" for adopting this practice is that executing "ordinary" SQL statements that would, when `AUTOCOMMIT` is `Off` start a transaction at the session's default isolation level, don't do this but rather are individually automatically committed. This is never a problem when you write application code because you always want to set the desired isolation level explicitly for all transactions—even those that have just a single SQL statement.

# The ysqlsh companion tests for the basic tests

These tests are described in the section *"A selection of basic tests designed to strengthen your understanding of the snapshot and serializable levels"*. They are implemented by files in the `basic_tests_ysqlsh_companion` subdirectory.

Notice these files: `blue_1.sql`, `red_1.sql`, `blue_2.sql`, `red_2.sql`, `blue_3.sql`, `red_3.sql`, and `blue_4.sql`. Run them in this order at the prompts of two concurrent `ysqlsh` sessions, running the `blue*` files in one session and the `red*` files in the other. (I found it convenient to set the backround color of each of the terminal windows appropriately.) But before you do this, read `blue_1.sql` and `red_1.sql`. You'll see the the first drops and creates the test table and that both invoke `set_isolation_level.sql`. Edit this to choose the isolation level at which to run the tests.

Also, before running the tests, read `blue_2.sql` and `red_2.sql`. You'll see that each has three lines exmplified by these from `blue_2.sql`:
```
   \i insert_same_row/blue_2.sql
-- \i update_same_row/blue_2.sql
-- \i delete_same_row/blue_2.sql
```
Uncomment one of these rows to choose the desired test in each of the two files.
