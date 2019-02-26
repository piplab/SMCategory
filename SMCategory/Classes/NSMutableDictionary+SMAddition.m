//
//  NSMutableDictionary+SMAddition.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "NSMutableDictionary+SMAddition.h"
#import "NSString+SMAddition.h"

@implementation NSMutableDictionary (SMAddition)
- (void)setInt:(int)number forKey:(id)key {
    [self setObject:[NSString stringWithInt:number] forKey:key];
}

- (void)setInteger:(NSInteger)number forKey:(id)key {
    [self setObject:[NSString stringWithInteger:number] forKey:key];
}

- (void)setShort:(short)number forKey:(id)key {
    [self setObject:[NSString stringWithShort:number] forKey:key];
}

- (void)setLong:(long)number forKey:(id)key {
    [self setObject:[NSString stringWithLong:number] forKey:key];
}

- (void)setLongLong:(long long)number forKey:(id)key {
    [self setObject:[NSString stringWithLongLong:number] forKey:key];
}

- (void)setFloat:(float)number forKey:(id)key {
    [self setObject:[NSString stringWithFloat:number] forKey:key];
}

- (void)setDouble:(double)number forKey:(id)key {
    [self setObject:[NSString stringWithDouble:number] forKey:key];
}

- (void)setBool:(BOOL)number forKey:(id)key {
    [self setObject:[NSString stringWithBool:number] forKey:key];
}

- (void)setInstance:(id)obj forKey:(id)key {
    !obj ?: [self setObject:obj forKey:key];
}
@end
