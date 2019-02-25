//
//  NSMutableArray+SMRange.m
//  SMCategory
//
//  Created by Simon on 2019/2/25.
//

#import "NSMutableArray+SMRange.h"

@implementation NSMutableArray (SMRange)
- (void)addInstance:(id)obj {
    if (obj) {
        [self addObject:obj];
    }
}

- (void)insertInstance:(id)obj atIndex:(NSUInteger)index {
    if (obj && index < self.count) {
        [self insertObject:obj atIndex:index];
    }
}

- (void)replaceInstanceAtIndex:(NSUInteger)index withObject:(id)obj {
    if (index < self.count && obj) {
        [self replaceObjectAtIndex:index withObject:obj];
    }
}

- (void)removeInstanceAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

@end
