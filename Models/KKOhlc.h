//
//  KKOhlc.h
//  KKDemo
//
//  Created by Manan Patel on 2/26/14.
//  Copyright (c) 2014 Manan Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKOhlc : NSObject
@property (nonatomic, assign) NSNumber *low;
@property (nonatomic, assign) NSNumber *high;
@property (nonatomic, assign) NSNumber *open;
@property (nonatomic, assign) NSNumber *close;
@property (nonatomic, assign) NSNumber *vwap;
@property (nonatomic, assign) NSNumber *volume;
@property (nonatomic, assign) NSDate *time;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)fetchCurrentDayOhlcs:(void (^)(NSArray *spreads, NSError *error))block;

@end