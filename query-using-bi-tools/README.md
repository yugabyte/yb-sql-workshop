## Goal

Explore RDBMS-like query support in YugaByte DB PostgreSQL. Note that you can perform all the steps below on a single machine (your laptop or desktop would be fine).

## Agenda

This exercise emulates the example of an ecommerce site. We will create the following tables and load them with meaningful, sample data:
* products : this table has details about the various products on the site
* users    : the various users of the site that can buy products
* orders   : the orders representing the product purchases the users have performed
* reviews  : reviews about products written by various people

We will then use the SQL query functionality of YugaByte DB to power business intelligence (often abbreviated to just *BI*) tools. Most BI tools rely on a wide range of query functionality from the underlying database. Here we will answer some questions about the ecommerce site, which in turn will require the following:
* Filter data using `WHERE` clauses
* Join data between tables
* Perform data aggregation using `GROUP BY`
* Use built-in functions such as `SUM`, `MIN`, `MAX`, etc.

We will use [Metabase](https://github.com/metabase/metabase), which is an open-source visual BI tool. Metabase is:
> The simplest, fastest way to get business intelligence and analytics to everyone in your company.

## Pre-requisites

You need the following in order to complete this exercise:
* A machine running mac or linux (laptop or desktop is fine).
* Java 1.8+
* You would need the `query-using-bi-tools` directory of this repo. You can clone the repo or download a zip version.

## Setup steps

We will first setup YugaByte DB, create the necessary tables, import sample data and then setup Metabase to use these tables and show us some analytics.

### Step 1: Install YugaByte DB

* [Download and install YugaByte DB](https://docs.yugabyte.com/latest/quick-start/) by following these quick start instructions. Remember to enable the postgres API when creating the cluster:
```
./bin/yb-ctl create --enable_postgres
```

* You should now be able to connect to the database by using `psql`:
```
bin/psql -p 5433 -U postgres
```

You should see a prompt as follows:
```
$ bin/psql -p 5433 -U postgres
psql (10.3, server 10.4)
Type "help" for help.

postgres=#
```

### Step 2: Create the necessary database and tables



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

### Step 3: Import the sample data

There is some sample data in `sample-data.tgz` file in this directory. Untar it by running the following: 
```
$ tar zxvf sample-data.tgz
```

You should see the following files after it is untar'ed:
```
$ ls data/
orders.sql  products.sql  reviews.sql  users.sql
```

Import the data by running the following:
```
yb_demo=# \i '/home/centos/metabase/data/products.sql
yb_demo=# \i '/home/centos/metabase/data/users.sql
yb_demo=# \i '/home/centos/metabase/data/orders.sql
yb_demo=# \i '/home/centos/metabase/data/reviews.sql
```

### Step 4: Install and setup Metabase

[Download the Metabase jar](https://metabase.com/start/jar.html) and run it to install.
```
$ wget http://downloads.metabase.com/v0.30.4/metabase.jar
$ java -jar metabase.jar
```
Next browse to http://IP_ADDRESS:3000 and continue with the installation. Remember to replace `IP_ADDRESS` with the ip address of your machine.

### Step 5: Point Metabase to the YugaByte DB table


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
yb_demo-# FROM users
yb_demo-# GROUP BY source
yb_demo-# ORDER BY num_user_signups DESC;
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
yb_demo-# FROM users, orders WHERE users.id=orders.user_id
yb_demo-# GROUP BY source
yb_demo-# ORDER BY total_sales DESC;
  source  | total_sales
----------+-------------
 Facebook |        3468
 Google   |        2331
 Twitter  |        1660
 Organic  |         568
(4 rows)
```

### Q4: What is the min, max and average price of products in the store?

```
yb_demo=# SELECT MIN(price), MAX(price), AVG(price) FROM products;
       min        |       max        |       avg
------------------+------------------+------------------
 15.6919436739704 | 98.8193368436819 | 55.7463996679207
(1 row)
```
