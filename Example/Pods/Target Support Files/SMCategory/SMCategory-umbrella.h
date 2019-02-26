#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+SMAddition.h"
#import "NSDictionary+SMAddition.h"
#import "NSMutableArray+SMAddition.h"
#import "NSMutableDictionary+SMAddition.h"
#import "NSString+SMAddition.h"

FOUNDATION_EXPORT double SMCategoryVersionNumber;
FOUNDATION_EXPORT const unsigned char SMCategoryVersionString[];

