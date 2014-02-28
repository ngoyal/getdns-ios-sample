getdns-ios
==========

iOS Sample Project for getdns

A project that shows [getdns](http://github.com/getdnsapi/getdns) in iOS.

## Quick Info

- A framework that can be linked is the getdns.framework folder.  Simply drag it into your XCode project and copy in files.
- Custom event loop in GDNSContext.m that attaches to the iOS event loop
- There is a bug in getdns 0.1.0 install that copies getdns_extra.h as the wrong file.  This framework has the proper one.
- simulator.m was grabbed from the [SSHCore](https://github.com/lhagan/SSHCore) project.  Many thanks for preventing much hair pulling.
- The getdns lib was modified to create an unbound context with threading (no fork)
- Architectures built: armv7 armv7s i386 (for simulator)
- Built with:
  - libunbound 1.4.21
  - libidn 1.28
  - ldns 1.6.17
  - openssl 1.0.1f
  - getdns 0.1.0 (with fixed header / context modifications)
- *important* make sure the scheme has an executable set.  Product -> Scheme -> Edit Scheme... -> Executable option


## TODO
 - Describe build / automation of getdns.framework .  Initial Credits:
   - https://github.com/hasseily/Makefile-to-iOS-Framework
   - http://www.cvursache.com/2013/08/13/How-To-Build-openssl-For-iOS/
 - Use getdns 0.1.1 when fixes are available
 - Use iOS blocks for async API
 - Fix memory management
 - Add wrappers so extensions / options can be passed as normal data structures (NSDictionary, NSArray, etc.)
 - Hide low level C api - replace w/ objective-c
