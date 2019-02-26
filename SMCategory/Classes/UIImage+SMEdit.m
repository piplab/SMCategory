//
//  UIImage+SMEdit.m
//  SMCategory
//
//  Created by Simon on 2019/2/26.
//

#import "UIImage+SMEdit.h"
#import <CoreImage/CoreImage.h>
#import <float.h>
#import <Accelerate/Accelerate.h>
#import <objc/runtime.h>

CGFloat degreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

CGFloat radiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}
@implementation UIImage (SMEdit)

+ (void)load {
    Method m1 = class_getClassMethod(self, @selector(imageNamed:));
    Method m2 = class_getClassMethod(self, @selector(hook_imageNamed:));
    method_exchangeImplementations(m1, m2);
}

+ (UIImage *)hook_imageNamed:(NSString *)name {
    UIImage *image = [self hook_imageNamed:name];
    if (image == nil) {
        NSLog(@"加载Image: \"%@\"失败", name);
    }
    return image;
}



- (UIImage*)imageWithScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithAspectScaledSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    CGFloat widthScale = newSize.width / self.size.width;
    CGFloat heightScale = newSize.height / self.size.height;
    CGFloat scale = MIN(widthScale, heightScale);
    CGSize drawSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    [self drawInRect:CGRectMake((newSize.width - drawSize.width) / 2, (newSize.height - drawSize.height) / 2, drawSize.width, drawSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// 根据UIImage.imageOrientation做rect的变化
- (CGRect)transformRect:(CGRect)rect {
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
            case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -self.size.height);
            break;
            case UIImageOrientationLeftMirrored:
            rectTransform = CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformMakeTranslation(-self.size.width, -self.size.height), -1, 1), M_PI_2);
            break;
            case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -self.size.width, 0);
            break;
            case UIImageOrientationRightMirrored:
            rectTransform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_2), -1, 1);
            break;
            case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -self.size.width, -self.size.height);
            break;
            case UIImageOrientationDownMirrored:
            rectTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -self.size.height), 1, -1);
            break;
            case UIImageOrientationUp:
            rectTransform = CGAffineTransformIdentity;
            break;
            case UIImageOrientationUpMirrored:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), -self.size.width, 0);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
            break;
    };
    
    
    return CGRectApplyAffineTransform(rect, rectTransform);
    
}


- (UIImage *)imageWithBright:(CGFloat)brightness {
    if (brightness == 0) {
        return self;
    }
    
    UIImage * result = nil;
    CIContext * context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}];
    CIImage * inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, inputImage, nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:kCIInputEVKey];
    
    CIImage * outputImage = filter.outputImage;
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    result = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgImage);
    return result;
}


- (UIImage *)maskedImage:(UIImage *)maskImage {
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage.CGImage), CGImageGetHeight(maskImage.CGImage), CGImageGetBitsPerComponent(maskImage.CGImage), CGImageGetBitsPerPixel(maskImage.CGImage), CGImageGetBytesPerRow(maskImage.CGImage), CGImageGetDataProvider(maskImage.CGImage), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(self.CGImage, mask);
    
    UIImage *result = [UIImage imageWithCGImage:masked scale:self.scale orientation:self.imageOrientation];
    
    CGImageRelease(mask);
    CGImageRelease(masked);
    
    return result;
}

- (UIImage *)blurImage:(UIImage *)blurImage andMask:(UIImage *)maskImage {
    UIImage * temp = [self maskedImage:maskImage];
    UIGraphicsBeginImageContext(blurImage.size);
    [blurImage drawAtPoint:CGPointZero];
    [temp drawInRect:CGRectMake(0, 0, blurImage.size.width, blurImage.size.height)];
    temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return temp;
}


- (UIImage *)circleBlurImage:(UIImage *)blurImage focusAtRect:(CGRect)rect andMaskImage:(UIImage *)maskImage {
    rect = [self transformRect:rect];
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    [maskImage drawInRect:rect];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self blurImage:blurImage andMask:maskImage];
}

- (UIImage*)gaussBlur:(CGFloat)blurLevel {
    if (blurLevel == 0) {
        return self;
    }
    
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage decode:self], 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend)?:
    vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    
    free(kernel);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}


- (UIImage *)clipImageWithRect:(CGRect)rect {
    rect = [self transformRect:rect];
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage * result = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return result;
}

+ (UIImage*)decode:(UIImage*)image
{
    if(image==nil){  return nil; }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}



- (UIImage *)rotateDegrees:(CGFloat)degrees {
    if (degrees == 0) {
        return self;
    }
    
    CGFloat angle = degreesToRadians(degrees);
    CGAffineTransform t = CGAffineTransformMakeRotation(angle);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGSize rotatedSize = CGRectApplyAffineTransform(rect, t).size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, angle);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:newImage.CGImage scale:newImage.scale orientation:self.imageOrientation];
}



- (UIImage *)bandBlurImage:(UIImage *)blurImage focusAtRect:(CGRect)rect andMaskImage:(UIImage *)maskImage {
    rect = [self transformRect:rect];
    maskImage = [UIImage imageWithCGImage:maskImage.CGImage scale:maskImage.scale orientation:self.imageOrientation];
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    [maskImage drawInRect:rect];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self blurImage:blurImage andMask:maskImage];
}


- (UIImage *)imageOverlayWithImage:(UIImage *)overlayImage alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointZero];
    [overlayImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *image  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)imageShadowCornerWithAlpha:(CGFloat)alpha andMaskImage:(UIImage *)maskImage {
    if (alpha == 0) {
        return self;
    }
    return [self imageOverlayWithImage:maskImage alpha:alpha];
}


+ (UIImage *)imageWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName andType:(NSString *)type {
    NSString * path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:type]];
}

- (BOOL)writeToFile:(NSString *)filePath {
    NSData *data = UIImageJPEGRepresentation(self, 1);
    return [data writeToFile:filePath atomically:YES];
}

+ (UIImage *)imageFromScreen {
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(NSString *)imageType{
    return nil;
}

- (UIImage *)applySubtleEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:3 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
        effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
        effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
@end
