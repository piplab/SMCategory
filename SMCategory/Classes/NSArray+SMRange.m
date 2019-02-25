//
//  NSArray+SMRange.m
//  SMCategory
//
//  Created by Simon on 2019/2/25.
//

#import "NSArray+SMRange.h"

@implementation NSArray (SMRange)
- (id)instanceAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}
@end
