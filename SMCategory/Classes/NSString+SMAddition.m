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

+ (NSString *)stringWithBool:(BOOL)number {
    return [NSString stringWithFormat:@"%d",number];
}

+ (NSString *)stringWithJsonObject:(id)obj {
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

- (id)jsonValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Json:%@ \nparse error:%@", self, error);
    }
    return obj;
}

- (NSDictionary *)jsonDictionary {
    id json = [self jsonValue];
    return [json isKindOfClass:NSDictionary.class] ? json : nil;
}

- (NSArray *)jsonArray {
    id json = [self jsonValue];
    return [json isKindOfClass:NSArray.class] ? json : nil;
}

- (NSUInteger)byteLength {
    NSUInteger strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

- (NSUInteger)chineseLength {
    float count = [self byteLength];
    return ceilf((count-1)/2);
}

- (CGSize)sizeForHavingWidth:(CGFloat)width withFont:(UIFont *)font {
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width, frame.size.height + 1);
}

@end
