

#import "KKSpread.h"
#import "KKAPIClient.h"



@implementation KKSpread
- (instancetype)initWithAttributes:(NSArray *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.ask = (NSNumber*)[attributes objectAtIndex:1];
    self.bid = (NSNumber*)[attributes objectAtIndex:2];
    
    return self;
}

+ (NSURLSessionDataTask *)fetchData:(void (^)(NSArray *spreads, NSError *error))block {
    return [[KKAPIClient sharedClient] GET:@"0/public/Spread?pair=xbteur" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *resultFromResponse = [JSON valueForKeyPath:@"result"];
        NSArray *spreadsFromResponse = [resultFromResponse valueForKey:@"XXBTZEUR"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[spreadsFromResponse count]];
        for (NSDictionary *attributes in spreadsFromResponse) {
            KKSpread *spread = [[KKSpread alloc] initWithAttributes:attributes];
            [mutablePosts addObject:spread];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
