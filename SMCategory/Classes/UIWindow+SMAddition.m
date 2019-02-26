//
//  UIWindow+SMAddition.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "UIWindow+SMAddition.h"

@implementation UIWindow (SMAddition)

- (UIViewController *)topViewController {
    UIViewController *topViewController = self.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    if ([topViewController isKindOfClass:UITabBarController.class]) {
        topViewController = [(UITabBarController *)topViewController selectedViewController];
    }
    if ([topViewController isKindOfClass:UINavigationController.class]) {
        topViewController = [[(UINavigationController *)topViewController childViewControllers] lastObject];
    }
    return topViewController;
}

- (NSArray *)viewControllerStack {
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    [self makeViewController:self.rootViewController inStack:stack];
    return [stack copy];
}


- (void)makeViewController:(UIViewController *)viewController inStack:(NSMutableArray *)stack {
    if (viewController == nil) {
        return;
    }
    if ([viewController isKindOfClass:UITabBarController.class]) {
        [self makeViewController:[(UITabBarController *)viewController selectedViewController] inStack:stack];
    } else if ([viewController isKindOfClass:UINavigationController.class]) {
        NSArray *childViewControllers = [viewController childViewControllers];
        [stack addObjectsFromArray:childViewControllers];
    } else {
        [stack addObject:viewController];
    }
    if (viewController.parentViewController == nil && viewController.presentedViewController) {
        [self makeViewController:viewController.presentedViewController inStack:stack];
    }
}
@end
