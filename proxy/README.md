install:
```console
client$ scp lib/simple_zlib.rb node:proxy/
client$ scp Dockerfile node:proxy/
client$ ssh node
server$ cd proxy
server$ docker build -t proxy .
server$ exit
client$ scp server_proxy.rb node:proxy/main.rb
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

check it's closed:
```console
client$ ssh node docker ps -a
```

note: timeout in server script should be larger than in client script, so we stop it via closing the connection
