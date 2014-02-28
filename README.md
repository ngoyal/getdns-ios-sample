getdns-ios
==========

iOS Sample Project for getdns

A project that shows [getdns](http://github.com/getdnsapi/getdns) in iOS.

## Quick Info

- A framework that can be linked is the getdns.framework folder.  Simply drag it into your XCode project and copy in files.
- Custom event loop in GDNSContext.m that attaches to the iOS event loop
- There is a bug in getdns 0.1.0 install that copies getdns_extra.h as the wrong file.  This framework has the proper one.
- simulator.m was grabbed from the [SSHCore](https://github.com/lhagan/SSHCore) project.  Many thanks for preventing much hair pulling.

## TODO
 - Describe build / automation of getdns.framework
 - Use iOS blocks for async API
 - Fix memory management
 
