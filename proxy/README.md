install:
```console
client$ scp Dockerfile node:proxy/
client$ ssh node
server$ cd proxy
server$ docker build -t proxy .
server$ exit
client$ scp Gemfile node:proxy/
client$ scp server_proxy.rb node:proxy/main.rb
client$ scp lib/simple_zlib.rb node:proxy/
```

update:
```console
client$ scp server_proxy.rb node:proxy/main.rb
```

usage:
```
client$ ruby get_url.rb "https://example.com" 2&>/dev/null

<!doctype html><html...
```

inspect all response lines:
```
client$ ruby debug.rb "https://example"

total lines: 1
nil "server error: HTTP error #404 Example DomainEx...
```

check it's closed:
```console
client$ ssh node docker ps -a
```

note: timeout in server script should be larger than in client script, so we stop it via closing the connection
