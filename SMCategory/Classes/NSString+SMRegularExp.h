//
//  NSString+SMRegularExp.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SMRegularExp)

/**
 *  是否为手机号码
 *
 *  @return 是否为手机号码
 */
- (BOOL)isMobileNumber;

/**
 *  是否为固定电话
 *
 *  @return 是否为固定电话
 */
- (BOOL)isTelephoneNumber;

/**
 *  是否为电子邮箱
 *
 *  @return 是否为电子邮箱
 */
- (BOOL)isEmail;

/**
 *  是否为QQ号码
 *
 *  @return 是否为QQ号码
 */
- (BOOL)isQQNumber;

/**
 *  是否为微信账号
 *
 *  @return 是否为微信账号
 */
- (BOOL)isWechat;

/**
 *  检查是不是一个数字（由0-9组成）
 *
 *  @return 是否是由0-9组成的数字
 */
- (BOOL)isNumber;
@end

NS_ASSUME_NONNULL_END
