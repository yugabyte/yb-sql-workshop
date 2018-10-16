## Goal

Explore RDBMS-like query support in YugaByte DB PostgreSQL. Note that you can perform all the steps below on a single machine (your laptop or desktop would be fine).

## Agenda

This exercise emulates the example of an ecommerce site. We will create the following tables and load them with meaningful, sample data:
* products : this table has details about the various products on the site
* users    : the various users of the site that can buy products
* orders   : the orders representing the product purchases the users have performed
* reviews  : reviews about products written by various people

We will then use the SQL query functionality of YugaByte DB to answer some questions about the ecommerce site. This in turn will require RDBMS-like query capabilities, for example:
* Filter data using `WHERE` clauses
* Join data between tables
* Perform data aggregation using `GROUP BY`
* Use built-in functions such as `SUM`, `MIN`, `MAX`, etc.

Optionally, we will point a business intelligence (often abbreviated to just *BI*) tool to visualize some of this information. We will use [Metabase](https://github.com/metabase/metabase), which is an open-source visual BI tool. Metabase is:
> The simplest, fastest way to get business intelligence and analytics to everyone in your company.

## Pre-requisites

You need the following in order to complete this exercise:
* A machine running mac or linux (laptop or desktop is fine).
* Java 1.8+
* You would need the `query-using-bi-tools` directory of this repo. You can clone the repo or download a zip version.

## Setup steps

We will first setup YugaByte DB, create the necessary tables, import sample data and then setup Metabase to use these tables and show us some analytics.

### Step 1: Untar the necessary files

We will work off the base working directory as shown below.
```
$ cd yb-sql-workshop
```

There is some sample data in `sample-data.tgz` file in this directory. Untar it by running the following:
```
tar zxvf query-using-bi-tools/sample-data.tgz
```

You should now see the data files as follows.
```
$ ls data/
orders.sql	products.sql	reviews.sql	users.sql
```

Connect to postgres shell.
```
./yugabyte-1.1.2.0/bin/psql -p 5433 -U postgres
```

### Step 2: Create the necessary database and tables

Create the necessary database with the `CREATE DATABASE` command.
```
postgres=# CREATE DATABASE yb_demo;
CREATE DATABASE
postgres=# GRANT ALL ON DATABASE yb_demo to postgres;
GRANT
```

Connect to the `yb_demo` database we just created.
```
postgres=# \c yb_demo ;
psql (10.3, server 10.4)
You are now connected to database "yb_demo" as user "postgres".
yb_demo=#
```

You can create the tables by running the `schema.sql` commands. You can find the `sample.sql` file in this directory. This will create the following 4 tables: `products`, `users`, `orders` and `reviews`.
```
yb_demo=# \i 'schema.sql'
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
```

Open the YugaByte DB cluster page by browsing to http://localhost:7000/ and explore these tables.

### Step 3: Import the sample data

Browse to the tablet servers page http://localhost:7000/tablet-servers to see the data getting loaded.

Import the data by running the following:
```
yb_demo=# \i 'data/products.sql'
yb_demo=# \i 'data/users.sql'
yb_demo=# \i 'data/orders.sql'
yb_demo=# \i 'data/reviews.sql'
```

## Queries to explore

### Q1: How are users signing up for my e-commerce site?

The `users` table has a `source` column which contains the channel from which the user was acquired. Let us find all the distinct values of this column. You can do so by running the following:
```
yb_demo=# SELECT DISTINCT(source) FROM users;
  source
-----------
 Facebook
 Twitter
 Organic
 Affiliate
 Google
(5 rows)
```

### Q2: What is the most effective channel for user signups?
This requires finding out how many users signed up from each of the channels, and finding the channel that resulted in the maximum. We can do so by running a `GROUP BY` aggregation on the `source` column, and sorting in a descending fashion by the number of signups.
```
yb_demo=# SELECT source, count(*) AS num_user_signups
          FROM users
          GROUP BY source
          ORDER BY num_user_signups DESC;
  source   | num_user_signups
-----------+------------------
 Facebook  |              512
 Affiliate |              506
 Google    |              503
 Twitter   |              495
 Organic   |              484
(5 rows)
```

### Q3: What is the most effective channel for product sales by revenue?

```
yb_demo=# SELECT source, ROUND(SUM(orders.total)) AS total_sales
          FROM users, orders WHERE users.id=orders.user_id
          GROUP BY source
          ORDER BY total_sales DESC;
  source   | total_sales
-----------+-------------
 Facebook  |      333454
 Google    |      325184
 Organic   |      319637
 Twitter   |      319449
 Affiliate |      297605
(5 rows)
```

### Q4: What is the min, max and average price of products in the store?

```
yb_demo=# SELECT MIN(price), MAX(price), AVG(price) FROM products;
       min        |       max        |       avg
------------------+------------------+------------------
 15.6919436739704 | 98.8193368436819 | 55.7463996679207
(1 row)
```

### Q5: What percentage of the total sales is from the Facebook channel?

Let us create a view to answer this question.
```
yb_demo=# CREATE VIEW channel AS
            (SELECT source, ROUND(SUM(orders.total)) AS total_sales
             FROM users, orders
             WHERE users.id=orders.user_id
             GROUP BY source
             ORDER BY total_sales DESC);
CREATE VIEW
```
You can see the view as follows:
```
yb_demo=# \d
          List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+----------
 public | channel  | view  | postgres
 public | orders   | table | postgres
 public | products | table | postgres
 public | reviews  | table | postgres
 public | users    | table | postgres
(5 rows)
```

Now we can find the percentage by running the following:
```
yb_demo=# SELECT source, total_sales * 100.0 / (SELECT SUM(total_sales) FROM channel) AS percent_sales
          FROM channel WHERE source='Facebook';
  source  |  percent_sales
----------+------------------
 Facebook | 20.9018954710909
(1 row)
```

## Using a BI tool (optional)

### Install and setup Metabase

[Download the Metabase jar](https://metabase.com/start/jar.html) and run it to install.
```
$ wget http://downloads.metabase.com/v0.30.4/metabase.jar
$ java -jar metabase.jar
```
Next browse to http://IP_ADDRESS:3000 and continue with the installation. Remember to replace `IP_ADDRESS` with the ip address of your machine.

### Point Metabase to the YugaByte DB table

You can do so by browsing to the admin page and clicking on the database tab. Here, you can set up a PostgreSQL database and point it at the YugaByte DB cluster we created above.

### Visualize queries

You can click on `Ask a Question` -> `Custom Query`. Choose the database we just setup, and enter the SQL query above into the editor.

