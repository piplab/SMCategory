//
//  NSString+SMEntry.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SMEntry)

- (NSString *)md5;

/**
 * Creates a SHA1 (hash) representation of NSString.
 *
 * @return NSString
 */
- (NSString *)sha1;

@end

NS_ASSUME_NONNULL_END
