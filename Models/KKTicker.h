
#import <Foundation/Foundation.h>

@interface KKTicker : NSObject

@property (nonatomic, assign) NSNumber *askPrice;
@property (nonatomic, assign) NSNumber *bidPrice;
@property (nonatomic, assign) NSNumber *f24hrVolume;
@property (nonatomic, assign) NSNumber *f24hrWap;
@property (nonatomic, assign) NSNumber *f24hrHigh;
@property (nonatomic, assign) NSNumber *f24hrLow;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)fetchData:(void (^)(KKTicker *ticker, NSError *error))block;


@end
