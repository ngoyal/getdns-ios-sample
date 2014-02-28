//
//  GDNSContext.h
//  getdnstest
//
//  Created by Goyal, Neel on 2/28/14.
//  Copyright (c) 2014 Goyal, Neel. All rights reserved.
//

#import <Foundation/Foundation.h>

struct getdns_context;

@interface GDNSContext : NSObject {
    struct getdns_context* ctx_;
}

-(struct getdns_context*) getContext;

@end
