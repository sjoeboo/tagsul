Tagsul: Query Tags in Consul
======

What?
-----

A little ruby program to let you query tags in consul, across services.

Why?
----

for `$reasons`, I wanted to be able to ask the question `What are the CORE services, what ports are those, and what systems run them?`. I wanted to be able to ask that/answer that, and know that the answer was current, and didn't involve a human updating a list. Consul's service registry does this work, but tagging item `core` didn't really help since the API (http and dns) didn't provide a way to show me all that info, across services. So, Tagsul.

How?
----
Its early days for Tagsul, but basically its a ruby wrapper hitting the consul http api. It asks for all services, then since that API call returns services with tags, filters them down to just the ones you want. Then it asks for each of THOSE services, pulls out the info we want (service, port, hosts and ips) and builds a list. Finally it gives you that info.

I also wanted an excuse to play with `sinatra`, so this is a good case for it.

Use
---

As a plain old ruby script:

```
./tagsul <consul_server_hostname:port>
```

(port defaults to 80 BTW)

As a docker container:

```
docker run -d -e CONSUL_HOST=<consul_server_hostname> -p PORT:4567 sjoeboo/tagsul
```
