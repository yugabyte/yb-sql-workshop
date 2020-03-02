# YugabyteDB PostgreSQL Workshop

This repo contains the requisite material for YugabyteDB PostgreSQL workshop.

## Setup

You can perform all the exercises below on a single mac or linux machine. A laptop or desktop would be fine since we are not focused on high throughput.

* You need to have installed JDK version 1.8+ on your machine to complete all the exercises.

* Download this repo. You can download the zip directory as follows:
```
wget https://github.com/YugaByte/yb-sql-workshop/archive/master.zip
unzip master.zip
```
Alternatively, you can clone this repository by running:
```
git clone git@github.com:YugaByte/yb-sql-workshop.git
```
Change your working directory to the repo, this will be our working space.
```
$ cd yb-sql-workshop
```

* Install YugabyteDB - You can download the binaries as follows:

  * macOS X
  ```
  wget https://downloads.yugabyte.com/yugabyte-ce-1.1.2.0-darwin.tar.gz
  tar xvfz yugabyte-ce-1.1.2.0-darwin.tar.gz && cd yugabyte-1.1.2.0/
  sudo ifconfig lo0 alias 127.0.0.2
  sudo ifconfig lo0 alias 127.0.0.3
  sudo ifconfig lo0 alias 127.0.0.4
  ```

  * Linux
  ```
  wget https://downloads.yugabyte.com/yugabyte-ce-1.1.2.0-linux.tar.gz
  tar xvfz yugabyte-ce-1.1.2.0-linux.tar.gz && cd yugabyte-1.1.2.0/
  ./bin/post_install.sh
  ```
To finish install, may need to set the open files ulimit to a larger value.
Check the current value with:
```
ulimit -n
```
If the value is small (e.g. `256`) do: 
```
ulimits -n 10000
```
Check that the value has been updated with: 
```
ulimits -n 
```

* Create a new cluster with PostgreSQL enabled.
```
./bin/yb-ctl create --enable_postgres
```

* You should now be able to connect to the database by using `psql`:
```
./bin/psql -p 5433 -U postgres
```

You should see a prompt as follows:
```
$ ./bin/psql -p 5433 -U postgres
psql (10.3, server 10.4)
Type "help" for help.

postgres=#
```

You can test the YSQL API using the steps listed [here](https://docs.yugabyte.com/latest/quick-start/explore-ysql/).

## [Exercise 1](query-using-bi-tools): Load sample data and perform queries

This exercise will explore RDBMS-like query support in YSQL. We will use the SQL query functionality of YugabyteDB to answer some questions about the ecommerce site. This in turn will require RDBMS-like query capabilities, for example:
* Filter data using WHERE clauses
* Join data between tables
* Perform data aggregation using GROUP BY
* Use built-in functions such as SUM, MIN, MAX, etc.

## [Exercise 2](https://www.slideshare.net/YugaByte/how-yugabyte-db-implements-distributed-postgresql): Understand architecture of distributed SQL in YugabyteDB

This exercise is a presentation where we will dive into how YugabyteDB internally handles sharding, replication, persistence and global ACID transactions while offering fault tolerance and the ability to scale out by adding nodes. We will map this architecture to how the following happen:
* Creating a table
* Writing data
* Handling SQL queries

## [Exercise 3](https://docs.yugabyte.com/latest/explore/postgresql/linear-scalability/): Understanding sharding and scale out with a SQL workload

In this exercise, we will look at how YugabyteDB internally shards data which enables it to scale. We will run a simple read-write SQL workload using a pre-packaged sample application against a 3-node local cluster with a replication factor of 3. We will then add nodes to it while the workload is running. We will then observe how the cluster scales out, by verifying that the number of read/write IOPS are evenly distributed across all the nodes at all times. We will finally scale the cluster back in to 3 nodes.


## [Exercise 4](https://docs.yugabyte.com/latest/explore/postgresql/fault-tolerance/): Understanding fault tolerance with a SQL workload

YugabyteDB automatically handles failures and therefore provides high availability for all the data stored. In this exercise, we will look at how fault tolerance is achieved. As before, we will run a simple read-write SQL workload using a pre-packaged sample application against a local cluster with a replication factor of 3. We will then simulate a node failure and make sure we are able to successfully query and write data after the failures. We will also look at how YugaByte DB automatically re-replicates data.


