//
//  NSString+SMAddition.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SMAddition)

+ (NSString *)stringWithInt:(int)number;

+ (NSString *)stringWithInteger:(NSInteger)number;

+ (NSString *)stringWithShort:(short)number;

+ (NSString *)stringWithLong:(long)number;

+ (NSString *)stringWithLongLong:(long long)number;

+ (NSString *)stringWithFloat:(float)number;

+ (NSString *)stringWithDouble:(double)number;

+ (NSString *)stringWithJsonObject:(id)obj;

- (id)jsonValue;

- (NSDictionary *)jsonDictionary;

- (NSArray *)jsonArray;

- (NSUInteger)byteLenth;

- (NSUInteger)chineseLength;

- (CGSize)sizeForHavingWidth:(CGFloat)width withFont:(UIFont *)font;


@end

NS_ASSUME_NONNULL_END
