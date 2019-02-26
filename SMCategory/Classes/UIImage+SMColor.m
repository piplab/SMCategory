//
//  UIImage+SMColor.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "UIImage+SMColor.h"

@implementation UIImage (SMColor)

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    return [self imageWithColor:color withOpaque:NO andSize:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color withOpaque:YES andSize:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color withOpaque:(BOOL)opaque andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, opaque, [UIScreen mainScreen].scale);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}
@end
