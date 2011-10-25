//
//  NSURL+IWCommon.h
//  iWish
//
//  Created by John Paul Alcala on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (IWCommon)

+(id)URLWithDictionary:(NSDictionary *)dictionary forURL:(NSURL *)url;

-(NSDictionary *)parameterDictionary;

@end
