//
//  GDNSContext.m
//  getdnstest
//
//  Created by Goyal, Neel on 2/28/14.
//  Copyright (c) 2014 Goyal, Neel. All rights reserved.
//

#import "GDNSContext.h"
#import <CFNetwork/CFNetwork.h>
#import <getdns/getdns.h>
#import <getdns/getdns_extra.h>

@implementation GDNSContext

struct nsrunloop_data {
    CFSocketRef cSock;
    CFRunLoopRef runLoop;
    CFRunLoopSourceRef source;
};

static void
request_count_changed(uint32_t request_count, struct nsrunloop_data *ev_data) {
    if (request_count > 0) {
        CFRunLoopAddSource(ev_data->runLoop, ev_data->source, kCFRunLoopCommonModes);
    } else {
        CFRunLoopRemoveSource(ev_data->runLoop, ev_data->source, kCFRunLoopCommonModes);
    }
}

static void readCallback (CFSocketRef s,
                          CFSocketCallBackType callbackType,
                          CFDataRef address,
                          const void *data,
                          void *info)
{
        
		GDNSContext *ctx = (__bridge GDNSContext *)info;
        struct getdns_context* context = [ctx getContext];
        getdns_context_process_async(context);
        uint32_t rc = getdns_context_get_num_pending_requests(context, NULL);
        struct nsrunloop_data* ev_data =
        (struct nsrunloop_data*) getdns_context_get_extension_data(context);
        request_count_changed(rc, ev_data);

}

// event loop

/* getdns extension functions */
static getdns_return_t
getdns_nsrunloop_request_count_changed(struct getdns_context* context,
                                      uint32_t request_count, void* eventloop_data) {
    struct nsrunloop_data *edata = (struct nsrunloop_data*) eventloop_data;
    request_count_changed(request_count, edata);
    return GETDNS_RETURN_GOOD;
}

static getdns_return_t
getdns_nsrunloop_cleanup(struct getdns_context* context, void* data) {
    struct nsrunloop_data *edata = (struct nsrunloop_data*) data;
    CFRunLoopRemoveSource(edata->runLoop, edata->source, kCFRunLoopCommonModes);
    CFRelease(edata->source);
    return GETDNS_RETURN_GOOD;
}

static getdns_return_t
getdns_nsrunloop_schedule_timeout(struct getdns_context* context,
                                 void* eventloop_data, uint16_t timeout,
                                 getdns_timeout_data_t* timeout_data,
                                 void** eventloop_timer) {
    
    return GETDNS_RETURN_GOOD;
}

static getdns_return_t
getdns_nsrunloop_clear_timeout(struct getdns_context* context,
                              void* eventloop_data, void* eventloop_timer) {
    return GETDNS_RETURN_GOOD;
}


static getdns_eventloop_extension nsrunloop_EXT = {
    getdns_nsrunloop_cleanup,
    getdns_nsrunloop_schedule_timeout,
    getdns_nsrunloop_clear_timeout,
    getdns_nsrunloop_request_count_changed
};

static getdns_return_t set_event_loop(getdns_context* ctx, GDNSContext* gctx) {
    int fd = getdns_context_fd(ctx);
    CFSocketContext theContext;
    theContext.version = 0;
    theContext.info = (__bridge void *)(gctx);
    theContext.retain = nil;
    theContext.release = nil;
    theContext.copyDescription = nil;
    CFSocketRef cSock = CFSocketCreateWithNative(kCFAllocatorDefault, fd, kCFSocketReadCallBack, readCallback, &theContext);
    struct nsrunloop_data* data = (struct nsrunloop_data*) malloc(sizeof(struct nsrunloop_data));
    data->cSock = cSock;
    data->source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, cSock, 0);
    data->runLoop = [[NSRunLoop currentRunLoop] getCFRunLoop];
    return getdns_extension_set_eventloop(ctx, &nsrunloop_EXT, data);
}
//

-(id) init {
    self = [super init];
    if (self) {
        getdns_context_create(&ctx_, 1);
        set_event_loop(ctx_, self);
    }
    return self;
}

-(getdns_context*) getContext {
    return ctx_;
}

-(void)dealloc {
    getdns_context_destroy(ctx_);
}

@end
