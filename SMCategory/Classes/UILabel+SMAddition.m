//
//  UILabel+SMAddition.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "UILabel+SMAddition.h"
#import <objc/runtime.h>

static void * VerticalAlignmentKey = &VerticalAlignmentKey;

@implementation UILabel (SMAddition)

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(drawRect:));
    Method m2 = class_getInstanceMethod(self, @selector(hook_drawRect:));
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:));
    Method m4 = class_getInstanceMethod(self, @selector(hook_textRectForBounds:limitedToNumberOfLines:));
    method_exchangeImplementations(m3, m4);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
- (CGSize)resizeHeight {
    CGFloat height = ceil([self.text boundingRectWithSize:self.bounds.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{ NSFontAttributeName:self.font }
                                                  context:nil].size.height);
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    return frame.size;
}

- (CGSize)resizeWithMaxWidth:(CGFloat)maxWidth {
    CGSize size;
    if ([@"" respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil] context:nil].size;
    } else {
        size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:self.lineBreakMode];
    }
    CGRect frame = self.frame;
    frame.size.width = ceilf(size.width);
    frame.size.height = ceilf(size.height);
    self.frame = frame;
    return frame.size;
}

- (CGSize)resizeWidthWithMaxWidth:(CGFloat)maxWidth {
    CGSize size;
    if ([@"" respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil] context:nil].size;
    } else {
        size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:self.lineBreakMode];
    }
    CGRect frame = self.frame;
    frame.size.width = ceilf(size.width);
    self.frame = frame;
    return frame.size;
    
    
}

- (void)setText:(NSString *)text withLineHeight:(CGFloat)lineHeight {
    if (text) {
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineHeightMultiple:lineHeight];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        self.attributedText = attributeText;
    } else {
        self.text = text;
    }
    
}

- (void)setText:(NSString *)text withLineSpace:(CGFloat)lineSpace {
    if (text) {
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        self.attributedText = attributeText;
    } else {
        self.text = text;
    }
}

+ (NSMutableAttributedString *)spacingFormatAttributedStringWithText:(NSString *)text
                                                           textColor:(UIColor *)textColor
                                                                font:(UIFont *)font
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                    characterSpacing:(CGFloat)characterSpacing
                                                         lineSpacing:(CGFloat)lineSpacing
                                                    paragraphSpacing:(CGFloat)paragraphSpacing {
    //去掉空行
    NSString *myString = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    //创建AttributeString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    NSMutableDictionary     *attributeDic   = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    // 首行头部缩进
    //    paragraphStyle.firstLineHeadIndent = 28.0f;
    
    // 设置左缩进
    //    paragraphStyle.headIndent = 20.0f;
    
    // 设置右缩进
    //    paragraphStyle.tailIndent = 20.0f;
    
    // 设置换行方式
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置文本对齐方式
    paragraphStyle.alignment = textAlignment;
    
    // 设置文本行间距
    paragraphStyle.lineSpacing = lineSpacing;
    
    // 设置文本段间距
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    
    // 设置字间距
    attributeDic[NSKernAttributeName] = @(characterSpacing);
    
    // 设置字体
    attributeDic[NSFontAttributeName] = font;
    
    // 设置颜色
    attributeDic[NSForegroundColorAttributeName] = textColor;
    
    // 设置段落属性
    attributeDic[NSParagraphStyleAttributeName] = paragraphStyle;
    
    // 应用格式化
    [attributedString addAttributes:attributeDic range:NSMakeRange(0, myString.length)];
    
    return attributedString;
}

- (CGRect)hook_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [self hook_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
            case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
            case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
            case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    objc_setAssociatedObject(self, VerticalAlignmentKey, @(verticalAlignment), OBJC_ASSOCIATION_RETAIN);
    [self setNeedsLayout];
}

- (VerticalAlignment)verticalAlignment {
    return [objc_getAssociatedObject(self, VerticalAlignmentKey) integerValue];
}

- (void)hook_drawRect:(CGRect)frame {
    CGRect actualRect = [self textRectForBounds:frame limitedToNumberOfLines:self.numberOfLines];
    [self hook_drawRect:actualRect];
}
@end
