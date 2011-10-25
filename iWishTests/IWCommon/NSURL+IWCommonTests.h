//
//  NSURL+IWCommonTests.h
//  iWish
//
//  Created by John Paul Alcala on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "NSURL+IWCommon.h"

@interface NSURL_IWCommonTests : SenTestCase {
    NSURL *url;
    NSDictionary *queryParams;
}

@end
