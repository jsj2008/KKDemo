//
//  KKOhlc.m
//  KKDemo
//
//  Created by Manan Patel on 2/26/14.
//  Copyright (c) 2014 Manan Patel. All rights reserved.
//

#import "KKOhlc.h"
#import "KKAPIClient.h"

@implementation KKOhlc

- (instancetype)initWithAttributes:(NSArray *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.low = (NSNumber*)[attributes objectAtIndex:3];
    self.high = (NSNumber*)[attributes objectAtIndex:2];
    self.open = (NSNumber*)[attributes objectAtIndex:1];
    self.close = (NSNumber*)[attributes objectAtIndex:4];
    self.vwap = (NSNumber*)[attributes objectAtIndex:5];
    self.time = [NSDate dateWithTimeIntervalSince1970:([[attributes objectAtIndex:0] integerValue])];
    self.volume = (NSNumber*)[attributes objectAtIndex:6];
    
    return self;
}


+ (NSURLSessionDataTask *)fetchCurrentDayOhlcs:(void (^)(NSArray *ohlcs, NSError *error))block {
    return [[KKAPIClient sharedClient] GET:@"0/public/OHLC?pair=xbteur&interval=30" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *resultFromResponse = [JSON valueForKeyPath:@"result"];
        NSArray *ohlcsFromResponse = [resultFromResponse valueForKey:@"XXBTZEUR"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[ohlcsFromResponse count]];

        for (NSDictionary *attributes in ohlcsFromResponse) {
            KKOhlc *ohlc = [[KKOhlc alloc] initWithAttributes:attributes];
            [mutablePosts addObject:ohlc];
        }
        
        NSArray* ret;
        if([mutablePosts count] > 48) {
            ret = [mutablePosts subarrayWithRange:NSMakeRange([mutablePosts count]-48, 48)];
        } else {
            if ([mutablePosts count] == 0) {
                return;
            } else {
                ret = [NSArray arrayWithArray:mutablePosts];
            }
        }
        
        if (block) {
            block(ret, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
