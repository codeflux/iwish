//
//  IWHttpRequest.m
//  iWish
//
//  Created by John Paul Alcala on 11/4/11.
//  Copyright (c) 2011 Codeflux Inc. All rights reserved.
//

#import "IWHttpRequest.h"
#import "NSString+IWCommon.h"
#import "NSURL+IWCommon.h"


@interface IWHttpRequest()

-(void)addToActiveRequests:(IWHttpRequest *)request;
-(void)removeFromActiveRequests:(IWHttpRequest *)request;
-(void)sendGETRequest;
-(void)sendPOSTRequest;
-(void)sendActualRequest:(NSURLRequest *)request;
-(void)initializeRequest;
-(void)successfulRequest;
-(void)finalizeRequest;
-(void)failedRequest;
-(void)closeStream;

@end

static NSMutableSet *activeRequests;

@implementation IWHttpRequest

@synthesize 
    URL, 
    response,
    error,
    responseData,
    requestParameters,
    downloadFilePath,
    POST,
    successBlock,
    failBlock,
    finallyBlock;


#pragma mark IWHttpRequest init methods

-(id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        URL=url;
        requestParameters=[NSMutableDictionary dictionary];
        POST=NO;
        
        response=nil;
        error=nil;
    }
    
    return self;
}

+(IWHttpRequest *)requestWithStringURL:(NSString *)stringURL {
    NSURL *requestURL=[NSURL URLWithString:stringURL];
    
    return [IWHttpRequest requestWithURL:requestURL];
}

+(IWHttpRequest *)requestWithURL:(NSURL *)url {
    IWHttpRequest *request=[[IWHttpRequest alloc] initWithURL:url];
    
    return request;
}


#pragma mark Methods for setting request parameters

-(void)setValue:(NSString *)value forRequestParameter:(NSString *)parameter {
    [requestParameters setValue:value forKey:parameter];
}


#pragma mark Methods for performing request

-(void)sendRequest {
    [self initializeRequest];
    
    if (POST) {
        [self sendPOSTRequest];
    } else {
        [self sendGETRequest];
    }
}


#pragma mark Private methods

-(void)addToActiveRequests:(IWHttpRequest *)request {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activeRequests=[[NSMutableSet alloc] init];
    });
    
    [activeRequests addObject:request];
}

-(void)removeFromActiveRequests:(IWHttpRequest *)request {
    [activeRequests removeObject:request];
}

-(void)initializeRequest {
    if (self.downloadFilePath) {
        downloadPathStream=[[NSOutputStream alloc] initToFileAtPath:self.downloadFilePath append:NO];
        [downloadPathStream open];
    } else {
        responseData=[[NSMutableData alloc] init];
    }
}

-(void)successfulRequest {
    if (self.successBlock) {
        self.successBlock();
    }
}

-(void)sendGETRequest {
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithDictionary:requestParameters forURL:URL]];
    
    [self sendActualRequest:request];
}

-(void)sendPOSTRequest {
    NSData *postData=[[NSString createQueryStringWithDictionary:requestParameters] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Post data: %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    [self sendActualRequest:request];
}

-(void)sendActualRequest:(NSURLRequest *)request {
    connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    if (!connection) {
        NSLog(@"Unable to establish a connection");
        
        [self failedRequest];
    } else {
        [self addToActiveRequests:self];
    }
}

-(void)finalizeRequest {
    if (self.finallyBlock) {
        self.finallyBlock();
    }
    
    [self removeFromActiveRequests:self];
}

-(void)failedRequest {
    if (self.failBlock) {
        self.failBlock();
    }
}

-(void)closeStream {
    if (downloadPathStream) {
        [downloadPathStream close];
    }
}


#pragma mark Delegate methods

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err {
    error=err;
    
    [self closeStream];
    
    [self failedRequest];
    [self finalizeRequest];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self closeStream];
    
    NSHTTPURLResponse *resp=(NSHTTPURLResponse *) response;
    
    if ([resp statusCode]==200) {
        [self successfulRequest];
    } else {
        [self failedRequest];
    }
    
    [self finalizeRequest];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)resp {
    response=resp;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (downloadPathStream) {
        NSUInteger bytesLeft=[data length];
        NSUInteger bytesWritten=0;
        
        while (bytesLeft>0) {
            bytesWritten=[downloadPathStream write:[data bytes] maxLength:[data length]];
            
            if (bytesWritten==-1) {
                break;
            }
            
            bytesLeft-=bytesWritten;
        }
    } else {
        [responseData appendData:data];
    }
}

@end
