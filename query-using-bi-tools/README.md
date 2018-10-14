## Goal

Explore RDBMS-like query support in YugaByte DB PostgreSQL.

In order to do so, we will create tables with sample data for a simple ecommerce site:
* products : this table has details about the various products on the site
* users    : the various users of the site that can buy products
* orders   : the orders representing the product purchases the users have performed
* reviews  : reviews about products written by various people

Note that you can perform all the steps below on a single machine (your laptop or desktop would be fine).

## Agenda

We will use the SQL functionality of YugaByte DB to power business intelligence (often abbreviated to just *BI*) tools. BI tools very often need to exercise a wide range of query functionality of the underlying database. Here we will view analytics which in turn will require the following:
* Filter data using `WHERE` clauses
* Join data between tables
* Perform data aggregation using `GROUP BY`
* Use built-in functions such as `SUM`, `MIN`, `MAX`, etc

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

### Step 2: Create the necessary tables

### Step 3: Import the sample data

### Step 4: Install and setup Metabase

### Step 5: Point Metabase to the YugaByte DB table


## Queries to explore


