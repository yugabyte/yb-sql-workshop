# YugaByte DB PostgreSQL Workshop

This repo contains the requisite material for YugaByte DB PostgreSQL workshop.

## Requirements

You can perform all the exercises below on a single mac or linux machine. A laptop or desktop would be fine since we are not focused on high throughput. You would need the following installed on the machine:

* JDK version 1.8+


## Exercise 1: Load sample data and perform queries

This exercise will explore RDBMS-like query support in YugaByte DB PostgreSQL. It emulates the example of an ecommerce site. We will create the following tables and load them with meaningful, sample data:
* products : this table has details about the various products on the site
* users : the various users of the site that can buy products
* orders : the orders representing the product purchases the users have performed
* reviews : reviews about products written by various people

We will then use the SQL query functionality of YugaByte DB to answer some questions about the ecommerce site. This in turn will require RDBMS-like query capabilities, for example:
* Filter data using WHERE clauses
* Join data between tables
* Perform data aggregation using GROUP BY
* Use built-in functions such as SUM, MIN, MAX, etc.

Optionally, we will point a business intelligence (often abbreviated to just BI) tool to visualize some of this information. We will use Metabase, which is an open-source visual BI tool. Metabase is:

## Exercise 2: Understand architecture of distributed SQL in YugaByte DB

This exercise is a presentation where we will dive into how YugaByte DB internally handles sharding, replication, persistence and global ACID transactions while offering fault tolerance and the ability to scale out by adding nodes. We will map this architecture to how the following happen:
* Creating a table
* Writing data
* Handling SQL queries

## Exercise 3: Understanding sharding and scale out with a SQL workload

## Exercise 4: Understanding fault tolerance with a SQL workload

