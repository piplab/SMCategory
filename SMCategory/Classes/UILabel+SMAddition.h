//
//  UILabel+SMAddition.h
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VerticalAlignment) {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface UILabel (SMAddition)

@property (nonatomic) VerticalAlignment verticalAlignment;

- (CGSize)resizeHeight;

- (CGSize)resizeWithMaxWidth:(CGFloat)maxWidth;

- (CGSize)resizeWidthWithMaxWidth:(CGFloat)maxWidth;


/**
 设置带间距的文字，单位为像素
 */
- (void)setText:(NSString *)text withLineSpace:(CGFloat)lineSpace;

/**
 设置带行高的文字，单位为倍数
 */
- (void)setText:(NSString *)text withLineHeight:(CGFloat)lineHeight;

+ (NSMutableAttributedString *)spacingFormatAttributedStringWithText:(NSString *)text
                                                           textColor:(UIColor *)textColor
                                                                font:(UIFont *)font
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                    characterSpacing:(CGFloat)characterSpacing
                                                         lineSpacing:(CGFloat)lineSpacing
                                                    paragraphSpacing:(CGFloat)paragraphSpacing;
@end

NS_ASSUME_NONNULL_END
