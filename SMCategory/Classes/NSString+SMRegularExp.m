//
//  NSString+SMRegularExp.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "NSString+SMRegularExp.h"

@implementation NSString (SMRegularExp)

- (BOOL)isMobileNumber {
    NSString *regex = @"1[\\d]{10}";    //  以1开头，11位数字
    return [self matchRegex:regex];
}

- (BOOL)isTelephoneNumber {
    NSString *regexpStr = @"^(0\\d{2,3}-?)?\\d{7,8}$";
    return [self matchRegex:regexpStr];
}

- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";  // 数字字母开头，@符号，数字字母.结尾，末尾2-4位
    return [self matchRegex:regex];
}

- (BOOL)matchRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isQQNumber {
    NSString *regex = @"[1-9][\\d]{4,14}";  // 数字1-9开头，5-15位
    return [self matchRegex:regex];
}

- (BOOL)isWechat {
    NSString *regex = @"[a-zA-Z\\d_]{5,22}";    // 0-9a-z_数字，5-22位
    return [self matchRegex:regex];
}

- (BOOL)isNumber {
    NSString *regex = @"[0-9]+";
    return [self matchRegex:regex];
}
@end
