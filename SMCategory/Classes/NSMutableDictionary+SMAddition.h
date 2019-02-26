//
//  NSMutableDictionary+SMAddition.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (SMAddition)

- (void)setInt:(int)number forKey:(id)key;

- (void)setInteger:(NSInteger)number forKey:(id)key;

- (void)setShort:(short)number forKey:(id)key;

- (void)setLong:(long)number forKey:(id)key;

- (void)setLongLong:(long long)number forKey:(id)key;

- (void)setFloat:(float)number forKey:(id)key;

- (void)setDouble:(double)number forKey:(id)key;

- (void)setBool:(BOOL)number forKey:(id)key;

- (void)setInstance:(id)obj forKey:(id)key;

@end

NS_ASSUME_NONNULL_END
