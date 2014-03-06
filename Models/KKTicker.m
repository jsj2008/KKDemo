

#import "KKTicker.h"
#import "KKAPIClient.h"



@implementation KKTicker
- (instancetype)initWithAttributes:(NSDictionary *)data {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.askPrice = (NSNumber*)[[data valueForKey:@"a"] objectAtIndex:0];
    self.bidPrice = (NSNumber*)[[data valueForKey:@"b"] objectAtIndex:0];
    self.f24hrVolume = (NSNumber*)[[data valueForKey:@"v"] objectAtIndex:1];
    self.f24hrWap = (NSNumber*)[[data valueForKey:@"p"] objectAtIndex:1];
    self.f24hrHigh = (NSNumber*)[[data valueForKey:@"h"] objectAtIndex:1];
    self.f24hrLow = (NSNumber*)[[data valueForKey:@"l"] objectAtIndex:1];
    
    return self;
}

+ (NSURLSessionDataTask *)fetchData:(void (^)(KKTicker *ticker, NSError *error))block {
    return [[KKAPIClient sharedClient] GET:@"0/public/Ticker?pair=xbteur" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *resultFromResponse = [JSON valueForKeyPath:@"result"];
        
        KKTicker* ticker = [[KKTicker alloc] initWithAttributes:[resultFromResponse valueForKeyPath:@"XXBTZEUR"]];
        
        if (block) {
            block(ticker, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(NULL, error);
        }
    }];
}

@end
