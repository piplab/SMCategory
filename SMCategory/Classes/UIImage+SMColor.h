//
//  UIImage+SMColor.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SMColor)

+ (UIImage *) createImageWithColor: (UIColor *) color;


+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color withOpaque:(BOOL)opaque andSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
