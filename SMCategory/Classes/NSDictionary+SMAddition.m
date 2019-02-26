//
//  NSDictionary+SMAddition.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "NSDictionary+SMAddition.h"

@implementation NSDictionary (SMAddition)
- (int)intForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(intValue)]) {
        return [obj intValue];
    }
    return 0;
}

- (NSInteger)integerForKey:(id)key {
    return [self integerForKey:key defaultValue:0];
}

- (NSInteger)integerForKey:(id)key defaultValue:(NSInteger)value {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(integerValue)]) {
        return [obj integerValue];
    }else {
        return value;
    }
}

- (short)shortForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(shortValue)]) {
        return [obj shortValue];
    }
    return 0;
}

- (long)longForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(longValue)]) {
        return [obj longValue];
    }
    return 0;
}

- (long long)longlongForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(longLongValue)]) {
        return [obj longLongValue];
    }
    return 0;
}

- (float)floatForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(floatValue)]) {
        return [obj floatValue];
    }
    return 0;
}

- (double)doubleForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(doubleValue)]) {
        return [obj doubleValue];
    }
    return 0;
}

- (BOOL)boolForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(boolValue)]) {
        return [obj boolValue];
    }
    return NO;
}

- (id)instanceForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj respondsToSelector:@selector(stringValue)]) {
        return [obj stringValue];
    }
    return [obj isKindOfClass:NSNull.class] ? nil : obj;
}

- (NSString *)parseToString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
@end
