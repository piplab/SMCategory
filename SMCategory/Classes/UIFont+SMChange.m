//
//  UIFont+SMChange.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "UIFont+SMChange.h"
#import <objc/runtime.h>

static NSString * kFontName = @"PingFangSC-Regular";
static NSString * kLightFontName = @"PingFangSC-Light";
static NSString * kBlodFontName = @"PingFangSC-Semibold";

@implementation UIFont (SMChange)

+ (void)load {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        kFontName = @"PingFangSC-Regular";
        kLightFontName = @"PingFangSC-Light";
        kBlodFontName = @"PingFangSC-Semibold";
    } else {
        kFontName = @"Helvetica";
        kLightFontName = @"Helvetica-Light";
        kBlodFontName = @"Helvetica-Bold";
    }
    Method origin = class_getClassMethod(self, @selector(fontWithName:size:));
    Method new = class_getClassMethod(self, @selector(chr_fontWithName:size:));
    method_exchangeImplementations(origin, new);
    
    origin = class_getClassMethod(self, @selector(systemFontOfSize:));
    new = class_getClassMethod(self, @selector(chr_systemFontOfSize:));
    method_exchangeImplementations(origin, new);
}

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize {
    UIFont *font = [self chr_fontWithName:kLightFontName size:fontSize];
    return font;
}
+ (UIFont *)regularFontOfSize:(CGFloat)fontSize {
    UIFont *font = [self chr_fontWithName:kFontName size:fontSize];
    return font;
}

+ (UIFont *)blodFontOfSize:(CGFloat)fontSize {
    UIFont *font = [self chr_fontWithName:kBlodFontName size:fontSize];
    return font;
}

+ (UIFont *)chr_fontWithName:(NSString *)fontName size:(CGFloat)size {
    if ([fontName hasSuffix:@"-Light"]) {
        return [self chr_fontWithName:kLightFontName size:size];
    } else if ([fontName hasSuffix:@"old"]) {
        return [self chr_fontWithName:kBlodFontName size:size];
    } else {
        return [self chr_fontWithName:kFontName size:size];
    }
}

+ (UIFont *)chr_systemFontOfSize:(CGFloat)fontSize {
    return [self chr_fontWithName:kFontName size:fontSize];
}
@end
