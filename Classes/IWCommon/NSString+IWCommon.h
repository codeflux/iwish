//
//  NSString+IWCommon.h
//  iWish
//
//  Created by John Paul Alcala on 11/4/11.
//  Copyright (c) 2011 Codeflux Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IWCommon)

+(NSString *)createQueryStringWithDictionary:(NSDictionary *)dictionary;

-(NSString *)encodeString;
-(NSString *)encodeStringUsingEncoding:(NSStringEncoding)encoding;

@end
