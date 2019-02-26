//
//  NSString+SMCookie.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 将单条Cookie字符串转成NSHTTPCookie对象
 Cookie的规范可以见相应的RFC文档 http://tools.ietf.org/html/rfc6265
 */
@interface NSString (SMCookie)

/*!
 当前字符串为单条cookie
 */
- (NSHTTPCookie *)cookie;

@end

NS_ASSUME_NONNULL_END
