//
//  KrakenAPIClient.h
//  JBChartViewDemo
//
//  Created by Manan Patel on 2/12/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface KKAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
