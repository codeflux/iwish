//
//  NSString+IWCommon.m
//  iWish
//
//  Created by John Paul Alcala on 11/4/11.
//  Copyright (c) 2011 Codeflux Inc. All rights reserved.
//

#import "NSString+IWCommon.h"

@implementation NSString (IWCommon)

+(NSString *)createQueryStringWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *queryString=[[NSMutableString alloc] init];
    for (NSString *key in [dictionary allKeys]) {
        if ([queryString length]>0) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", [key encodeString], [[dictionary objectForKey:key] encodeString]];
    }
    
    return queryString;
}

-(NSString *)encodeString {
    return [self encodeStringUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)encodeStringUsingEncoding:(NSStringEncoding)encoding {
    NSString *encodedString=(__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(nil, 
                                                   (__bridge CFStringRef)self, 
                                                   nil, 
                                                   (__bridge CFStringRef)@" `~!@#$%^&*()=+[]{}\\|;:'\",./<>?", 
                                                   CFStringConvertNSStringEncodingToEncoding(encoding));

    return encodedString;
}

@end
