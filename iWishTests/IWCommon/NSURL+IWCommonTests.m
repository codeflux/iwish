//
//  NSURL+IWCommonTests.m
//  iWish
//
//  Created by John Paul Alcala on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSURL+IWCommonTests.h"

@implementation NSURL_IWCommonTests

-(void)setUp {
    url=[NSURL URLWithString:@"http://www.facebook.com/dialog/oauth/"];
    queryParams=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                     @"touch",
                                                     @"user_birthday,publish_stream,read_stream",
                                                     @"249783355064843",
                                                     @"fbconnect://success",
                                                     @"token",
                                                     nil]
                                            forKeys:[NSArray arrayWithObjects:
                                                     @"display",
                                                     @"scope",
                                                     @"client_id",
                                                     @"redirect_uri",
                                                     @"response_type",
                                                     nil]];
}

-(void)testParseParams {
    NSURL *testURL=[NSURL URLWithString:@"http://www.facebook.com/dialog/oauth/?display=touch&scope=user_birthday,publish_stream,read_stream&client_id=249783355064843&redirect_uri=fbconnect://success&response_type=token"];
    NSDictionary *params=[testURL parameterDictionary];
    
    for (NSString *param in params) {
        NSString *value=[queryParams objectForKey:param];
        STAssertTrue(value!=nil, @"No matching value for key: %@. Value found was %@", param, value);
    }
    
    // reverse the process. create a URL from a map.
    NSURL *createdURL=[NSURL URLWithDictionary:queryParams forURL:url];
    params=[createdURL parameterDictionary];
    
    // ensure that we get the original params.
    for (NSString *param in params) {
        NSString *value=[queryParams objectForKey:param];
        STAssertTrue(value!=nil, @"No matching value for key: %@. Value found was %@", param, value);
    }
}

@end
