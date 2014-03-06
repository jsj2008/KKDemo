//
//  KrakenAPIClient.m
//  JBChartViewDemo
//
//  Created by Manan Patel on 2/12/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "KKAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.kraken.com";

@implementation KKAPIClient

+ (instancetype)sharedClient {
    static KKAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KKAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

@end
