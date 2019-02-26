//
//  UIWindow+SMAddition.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (SMAddition)

/**
 *  获取当前栈顶的ViewController
 */
@property (readonly, nonatomic) UIViewController *topViewController;

/**
 *  获取全部的页面栈，数组元素为UIViewController
 */
@property (readonly, nonatomic) NSArray *viewControllerStack;
@end

NS_ASSUME_NONNULL_END
