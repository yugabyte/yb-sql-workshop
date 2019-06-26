The filenames are self-explanatory. Looks at them first, in this order:

### cr_tables.sql
This does the DDLs. It first drops "if exists" the four tables that implement the tescase (customers, items, orders, and order_lines) and then creates them, together with their supporting objects.

### populate_tables.sql
This inserts a small, but suffieiently illustrative, number of rows into each of the tables.

### queries.sql
This demonstrates the "select" statements shown in the blog post, finishing with a "group by" based on an inner join of all the four tables.

### DMLs.sql
This demonstrates the delete and insert statements shown in the blog post that show the effect of "on delete restrict",  "on delete casade", and the the basic effect the the FK constraint to prevent "orphan" child rows.

### do_all.sql
You might like to run all of the four demo scripts, in order, and mechanically, simply by starting "do_all.sql" at the "ysqlsh" prompt. You can simply start "do_all.sql" time and again. It always has the same effect.

### startup.sql
Notice that it begins by startin "startup.sql". This does no SQL but simply uses meta-commands to produce the quietest possible output. Comment it out if you don't like its effect.