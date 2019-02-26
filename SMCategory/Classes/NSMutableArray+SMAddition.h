//
//  NSMutableArray+SMRange.h
//  SMCategory
//
//  Created by Simon on 2019/2/25.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (SMAddition)

- (void)addInstance:(id)obj;
- (void)insertInstance:(id)obj atIndex:(NSUInteger)index;
- (void)replaceInstanceAtIndex:(NSUInteger)index withObject:(id)obj;
- (void)removeInstanceAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
