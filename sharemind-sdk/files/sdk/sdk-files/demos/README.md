# SecreC code examples

The example code has been divided into the following categories:

* `basic` - The very basic usage of SecreC
* `database` - Examples of how to use the table database and key-value database interfaces in SecreC
* `domains` - Demonstrates usage of different protection domains.

## Key-value database example

The example in `database/keydb_example.sc` makes use of the key-value based mod_keydb module that uses Redis server for its storage. Redis server software is already installed starts automatically on boot. Server log is in `/var/log/redis/redis-server.log`.
To check if the Redis server is running or start it manually, use:

```
$ sudo /etc/init.d/redis-server status
$ sudo /etc/init.d/redis-server start
```
