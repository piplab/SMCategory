//
//  NSString+SMAddition.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "NSString+SMAddition.h"

@implementation NSString (SMAddition)
+ (NSString *)stringWithInt:(int)number {
    return [NSString stringWithFormat:@"%d",number];
}

+ (NSString *)stringWithInteger:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld",(long)number];
}

+ (NSString *)stringWithShort:(short)number {
    return [NSString stringWithFormat:@"%d",number];
}

+ (NSString *)stringWithLong:(long)number {
    return [NSString stringWithFormat:@"%ld",number];
}

+ (NSString *)stringWithLongLong:(long long)number {
    return [NSString stringWithFormat:@"%lld",number];
}

+ (NSString *)stringWithFloat:(float)number {
    return [NSString stringWithFormat:@"%f",number];
}

+ (NSString *)stringWithDouble:(double)number {
    return [NSString stringWithFormat:@"%f",number];
}

+ (NSString *)stringWithJsonObject:(id)obj {
    
}

- (id)jsonValue {
    
}

- (NSDictionary *)jsonDictionary {
    
}

- (NSArray *)jsonArray {
    
}

- (NSUInteger)byteLenth {
    
}

- (NSUInteger)chineseLength {
    
}

- (CGSize)sizeForHavingWidth:(CGFloat)width withFont:(UIFont *)font {
    
}

@end
