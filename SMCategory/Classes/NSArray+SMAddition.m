//
//  NSArray+SMRange.m
//  SMCategory
//
//  Created by Simon on 2019/2/25.
//

#import "NSArray+SMAddition.h"

@implementation NSArray (SMAddition)
- (id)instanceAtIndex:(NSUInteger)index {
    if (index < self.count) {
        id obj = [self objectAtIndex:index];
        return [obj isKindOfClass:[NSNull class]] ? nil : obj;
    }
    return nil;
}
@end
