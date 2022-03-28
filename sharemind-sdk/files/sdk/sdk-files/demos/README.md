# SecreC code examples

The example code has been divided into the following categories:

* `basic` - The very basic usage of SecreC
* `database` - Examples of how to use the table database and key-value database interfaces in SecreC
* `domains` - Demonstrates the usage of different protection domains.

## Running the SecreC code

### In QtCreator

1. Open the SecreC code in QtCreator
2. Use _Tools->External->Sharemind SDK->Run SecreC_ (Ctrl+F2) to compile and run SecreC files.
3. Use _Tools->External->Sharemind SDK->Analyze SecreC_ (Ctrl+Shift+F2) to compile, run and then analyze SecreC files.

### From command-line

1. Use `sm_compile.sh [secrec-code.sc]` to compile SecreC files.
2. Use `sm_compile_and_run.sh [secrec-code.sc]` to compile and run SecreC files.
3. Use `sm_compile_and_run_and_analyze.sh [secrec-code.sc]` to compile, run and then analyze SecreC files.
4. Use `sm_run_tests.sh` to run the SecreC Standard Library tests.

## Key-value database example

The example in `database/keydb_example.sc` makes use of the key-value based _mod_keydb_ module that uses Redis server for its storage. Redis server software is already installed and starts automatically on boot. Server log is in `/var/log/redis/redis-server.log`.
To check if the Redis server is running or to start it manually, use:

```
sudo systemctl status redis-server
sudo systemctl start redis-server
```
