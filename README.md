# YugaByte DB PostgreSQL Workshop

This repo contains the requisite material for YugaByte DB PostgreSQL workshop.

## Requirements

You can perform all the exercises below on a single mac or linux machine. A laptop or desktop would be fine since we are not focused on high throughput. You would need the following installed on the machine:

* JDK version 1.8+

* Download this repo. Alternatively, you can clone this repository by running:
```
git clone git@github.com:YugaByte/yb-sql-workshop.git
```


## [Exercise 1](query-using-bi-tools): Load sample data and perform queries

This exercise will explore RDBMS-like query support in YugaByte DB PostgreSQL. We will use the SQL query functionality of YugaByte DB to answer some questions about the ecommerce site. This in turn will require RDBMS-like query capabilities, for example:
* Filter data using WHERE clauses
* Join data between tables
* Perform data aggregation using GROUP BY
* Use built-in functions such as SUM, MIN, MAX, etc.

## Exercise 2: Understand architecture of distributed SQL in YugaByte DB

This exercise is a presentation where we will dive into how YugaByte DB internally handles sharding, replication, persistence and global ACID transactions while offering fault tolerance and the ability to scale out by adding nodes. We will map this architecture to how the following happen:
* Creating a table
* Writing data
* Handling SQL queries

## [Exercise 3](https://docs.yugabyte.com/latest/explore/): Understanding sharding and scale out with a SQL workload

In this exercise, we will look at how YugaByte DB internally shards data which enables it to scale. We will run a simple read-write SQL workload using a pre-packaged sample application against a 3-node local cluster with a replication factor of 3. We will then add nodes to it while the workload is running. We will then observe how the cluster scales out, by verifying that the number of read/write IOPS are evenly distributed across all the nodes at all times.


## [Exercise 4](https://docs.yugabyte.com/latest/explore/): Understanding fault tolerance with a SQL workload

YugaByte DB can automatically handle failures and therefore provides high availability for PostgreSQL (as well as Redis and Cassandra) tables. In this exercise, we will look at how fault tolerance is achieved. As before, we will run a simple read-write SQL workload using a pre-packaged sample application against a local cluster with a replication factor of 3. We will then simulate a node failure and make sure we are able to successfully query and write data after the failures. We will also look at how YugaByte DB automatically re-replicates data.


