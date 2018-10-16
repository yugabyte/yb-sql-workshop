
## Running the load tester

```
java -jar running-sample-apps/yb-sample-apps.jar \
    --nodes 127.0.0.1:5433     \
    --workload SqlInserts      \
    --num_threads_write 2      \
    --num_threads_read 2       \
    --nouuid                   \
    --num_unique_keys 10000000
```

## Add a node
```
./yugabyte-1.1.2.0/bin/yb-ctl add_node
```

## Check status

```
$ ./yugabyte-1.1.2.0/bin/yb-ctl status
2018-10-15 23:15:39,206 INFO: Server is running: type=master, node_id=1, PID=9265, admin service=http://127.0.0.1:7000
2018-10-15 23:15:39,253 INFO: Server is running: type=master, node_id=2, PID=9268, admin service=http://127.0.0.2:7000
2018-10-15 23:15:39,297 INFO: Server is running: type=master, node_id=3, PID=9271, admin service=http://127.0.0.3:7000
2018-10-15 23:15:39,342 INFO: Server is running: type=tserver, node_id=1, PID=9274, admin service=http://127.0.0.1:9000, cql service=127.0.0.1:9042, redis service=127.0.0.1:6379
2018-10-15 23:15:39,388 INFO: Server is running: type=tserver, node_id=2, PID=9277, admin service=http://127.0.0.2:9000, cql service=127.0.0.2:9042, redis service=127.0.0.2:6379
2018-10-15 23:15:39,433 INFO: Server is running: type=tserver, node_id=3, PID=9280, admin service=http://127.0.0.3:9000, cql service=127.0.0.3:9042, redis service=127.0.0.3:6379
2018-10-15 23:15:39,475 INFO: Server is running: type=tserver, node_id=4, PID=11270, admin service=http://127.0.0.4:9000, cql service=127.0.0.4:9042, redis service=127.0.0.4:6379
2018-10-15 23:15:39,520 INFO: Server is running: type=postgres, node_id=1, PID=9293, pgsql service=127.0.0.1:5433
```

## Remove a node

```
$ ./yugabyte-1.1.2.0/bin/yb-ctl remove_node 4
2018-10-15 23:18:14,095 INFO: Stopping server tserver-4
2018-10-15 23:18:14,141 INFO: Stopping server tserver-4 PID=11270
2018-10-15 23:18:14,142 INFO: Waiting for server tserver-4 PID=11270 to stop...
```

## Remove its data and restart the node

```
rm -rf /tmp/yugabyte-local-cluster/node-4/
du -hs /tmp/yugabyte-local-cluster/*
./yugabyte-1.1.2.0/bin/yb-ctl add_node
```

## Add yet another node
