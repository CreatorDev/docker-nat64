[![Creator Logo](http://static.creatordev.io/logo.png)](http://www.creatordev.io)

----

# Docker-NAT64

## Intro

This is a little docker container to run a IPv6 to IPv4 NAT ("NAT64") system.
It will be used for automated testing [Contiki](https://github.com/CreatorDev/contiki)
systems as part of the [Creator System Test Framework](https://github.com/CreatorDev/creator-system-test-framework).

**NB:** It's not quite working yet .. hoping to get a proof-of-concept running.

## Credits

Thanks to the following projects:

- [Tayga](http://www.litech.org/tayga/)
- [TOTD](https://github.com/fwdillema/totd)

See also:

- Shawn Tan's [blog post](http://tech.sybreon.com/2015/05/05/nat64dns64-on-openwrt/)
  for achieving the same thing on OpenWRT.
- [unique-local-ipv6.com](http://unique-local-ipv6.com/) for generating
  your own local IPv6 addresses.