//
//  NSURL+IWCommon.m
//  iWish
//
//  Created by John Paul Alcala on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSURL+IWCommon.h"

@interface NSURL()

+(NSString *)createQueryStringWithDictionary:(NSDictionary *)dictionary;

@end

@implementation NSURL (IWCommon)

+(id)URLWithDictionary:(NSDictionary *)dictionary forURL:(NSURL *)url {
    NSString *queryParams=[NSURL createQueryStringWithDictionary:dictionary];
    NSMutableString *newURL=[NSMutableString stringWithString:[url absoluteString]];
    
    if ([newURL length]>0) {
        [newURL appendFormat:@"?%@", queryParams];
    }
    
    return [NSURL URLWithString:newURL];
}

-(NSDictionary *)parameterDictionary {
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    for (NSString *param in [[self query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]]) {
        NSArray *pair=[param componentsSeparatedByString:@"="];
        if ([pair count]<2) {
            continue;
        }
        
        [params setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    
    return params;
}

#pragma mark Private methods

+(NSString *)createQueryStringWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *queryString=[[NSMutableString alloc] init];
    for (NSString *key in [dictionary allKeys]) {
        if ([queryString length]>0) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", key, [dictionary objectForKey:key]];
    }
    
    return queryString;
}

@end
