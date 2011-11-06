# Hydra: load-balanced (multi-headed) SOCKS5 proxy

Given a list of hosts hydra opens a pool of SOCKS5 tunnels and routes incoming requests via a random tunnel. In effect, hydra is a regular SOCKS5 proxy, except that each outbound request is automatically load-balanced.

[img]

Hydra uses SSH to establish the SOCKS5 tunnels and [em-proxy](https://github.com/igrigorik/em-proxy) to provide the transparent routing for any SOCKS5 compatible client.

## Getting started

```
$> gem install hydra
$> hydra --listen 8080 --hosts host1,host2 --key ssh_key.pub --verbose
```

```ruby
c = Curl::Easy.new('http://whatismyip.org')
c.proxy_url = 'localhost:8080'
c.proxy_type = Curl::CURLPROXY_SOCKS5
c.perform
c.body_str

```

## License

The MIT License - Copyright (c) 2011 Ilya Grigorik