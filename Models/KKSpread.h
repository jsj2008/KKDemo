
#import <Foundation/Foundation.h>

@interface KKSpread : NSObject

@property (nonatomic, assign) NSNumber *ask;
@property (nonatomic, assign) NSNumber *bid;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)fetchData:(void (^)(NSArray *spreads, NSError *error))block;


@end
