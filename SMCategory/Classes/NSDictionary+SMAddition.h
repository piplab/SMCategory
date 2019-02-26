//
//  NSDictionary+SMAddition.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SMAddition)
/**
 基本数据类型
 */
- (int)intForKey:(id)key;

- (NSInteger)integerForKey:(id)key;

- (NSInteger)integerForKey:(id)key defaultValue:(NSInteger)value;

- (short)shortForKey:(id)key;

- (long)longForKey:(id)key;

- (long long)longlongForKey:(id)key;

- (float)floatForKey:(id)key;

- (double)doubleForKey:(id)key;

- (BOOL)boolForKey:(id)key;
/**
 过滤掉NSNull, 如果是NSNumber对象，则转化为string
 */
- (id)instanceForKey:(id)key;

- (NSString *)parseToString;

@end

NS_ASSUME_NONNULL_END
