This code zip accompanies the blog post ["Relational Data Modeling with Foreign Keys in a Distributed SQL Database"](https://blog.yugabyte.com/relational-data-modeling-with-foreign-keys-in-a-distributed-sql-database/). Use that post as the external documentation for this code. The filenames are self-explanatory. Look at them first, in this order:

### cr_tables.sql
This does the DDLs. It first drops `if exists` the four tables that implement the tescase (`customers`, `items`, `orders`, and `order_lines`) and then creates them, together with their supporting objects.

### populate_tables.sql
This inserts a small, but sufficiently illustrative, number of rows into each of the tables.

### queries.sql
This demonstrates the `select` statements shown in the blog post, finishing with a `group by` based on an inner join of all the four tables.

### DMLs.sql
This demonstrates the `delete` and `insert` statements shown in the blog post that show the effect of `on delete restrict`,  `on delete casade`, and the the basic effect the the foreign key constraint to prevent "orphan" child rows.

### do_all.sql
You might like to run all of the four demo scripts, in order, and mechanically, simply by starting `do_all.sql` at the `ysqlsh` prompt. You can simply start it time and again. It always has the same effect.

### startup.sql
Notice that it begins by starting `startup.sql`. This does no SQL but simply uses meta-commands to produce the quietest possible output. Comment it out if you don't like its effect.
