//
//  IWHttpRequest.h
//  iWish
//
//  Created by John Paul Alcala on 11/4/11.
//  Copyright (c) 2011 Codeflux Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(void);
typedef void(^FailBlock)(void);
typedef void(^FinallyBlock)(void);

@interface IWHttpRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    @private
    NSURL *URL;
    NSURLResponse *response;
    NSError *error;
    NSMutableData *responseData;
    NSMutableDictionary *requestParameters;
    BOOL POST;
    NSString *downloadFilePath;
    NSOutputStream *downloadPathStream;
    NSURLConnection *connection;
    
    SuccessBlock successBlock;
    FailBlock failBlock;
    FinallyBlock finallyBlock;
}

@property(nonatomic, readonly) NSURL *URL;
@property(nonatomic, readonly) NSURLResponse *response;
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) NSData *responseData;
@property(nonatomic, retain) NSDictionary *requestParameters;
@property(nonatomic, retain) NSString *downloadFilePath;
@property(nonatomic) BOOL POST;

@property(nonatomic, copy) SuccessBlock successBlock;
@property(nonatomic, copy) FailBlock failBlock;
@property(nonatomic, copy) FinallyBlock finallyBlock;

-(id)initWithURL:(NSURL *)url;
+(IWHttpRequest *)requestWithStringURL:(NSString *)stringURL;
+(IWHttpRequest *)requestWithURL:(NSURL *)url;

-(void)setValue:(NSString *)value forRequestParameter:(NSString *)parameter;
-(void)sendRequest;

@end
