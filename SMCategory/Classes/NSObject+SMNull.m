//
//  NSObject+SMNull.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "NSObject+SMNull.h"

@implementation NSObject (SMNull)
- (id)filterOutNull {
    return [self isKindOfClass:NSNull.class] ? nil : self;
}
@end
