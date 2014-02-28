//
//  GDNSViewController.m
//  getdnstest
//
//  Created by Goyal, Neel on 2/28/14.
//  Copyright (c) 2014 Goyal, Neel. All rights reserved.
//

#import "GDNSViewController.h"
#import <getdns/getdns.h>
#import "GDNSContext.h"

@interface GDNSViewController ()

@property (strong, nonatomic) GDNSContext* context;

@end

@implementation GDNSViewController

void this_callbackfn(getdns_context *this_context,
                     getdns_callback_type_t this_callback_type,
                     getdns_dict *this_response,
                     void *this_userarg,
                     getdns_transaction_t this_transaction_id)
{
    if (this_callback_type == GETDNS_CALLBACK_COMPLETE && this_response)  /* This is a callback with data */
	{
        char* pp = getdns_pretty_print_dict(this_response);
        NSLog(@"%s", pp);
        free(pp);
        getdns_dict_destroy(this_response);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [[GDNSContext alloc] init];
    getdns_address([self.context getContext], "getdnsapi.net", NULL, NULL, NULL, this_callbackfn);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
