//
//  NSString+IWCommonTests.m
//  iWish
//
//  Created by John Paul Alcala on 11/4/11.
//  Copyright (c) 2011 Codeflux Inc. All rights reserved.
//

#import "NSString+IWCommonTests.h"
#import "NSString+IWCommon.h"

@implementation NSString_IWCommonTests

// All code under test must be linked into the Unit Test bundle
- (void)testEncodeString
{
    NSString *expected=@"%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%25%23%5B%5D";
    NSString *rawQuery=@"!*'();:@&=+$,/?%#[]";
    
    NSString *actual=[rawQuery encodeString];
    STAssertTrue([expected isEqualToString:actual], @"Query strings do not match.\nExpected: %@\nActual:%@", expected, actual);
}

@end
