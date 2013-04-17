//
//  PDCBackgroundImageView.m
//  greenscreen
//
//  Created by koba on 4/16/13.
//  Copyright (c) 2013 Pas de Chocolat. All rights reserved.
//

#import "PDCBackgroundImageView.h"

@interface PDCBackgroundImageView ()
+ (CIFilter *)checkerboardFilterForSize:(CGSize)size;
+ (CIFilter *)cropFilterForSize:(CGSize)size scale:(CGFloat)scale inputImage:(CIImage *)inputImage;
+ (UIImage *)uiimageFromCIImage:(CIImage *)ciimage scale:(CGFloat)scale context:(CIContext *)context;
@end

@implementation PDCBackgroundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CIFilter *)checkerboardFilterForSize:(CGSize)size
{
    NSNumber *twoSquareWidth = @(8);
    return [CIFilter filterWithName:@"CICheckerboardGenerator"
                      keysAndValues:
            @"inputColor0", [CIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f],
            @"inputColor1", [CIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f],
            @"inputWidth", twoSquareWidth,
            @"inputCenter", [CIVector vectorWithX:size.width/2.0f Y:size.height/2.0f],
            nil];
}

+ (CIFilter *)cropFilterForSize:(CGSize)size scale:(CGFloat)scale inputImage:(CIImage *)inputImage
{
    CGRect cropRect = CGRectZero;
    cropRect.size = size;
    cropRect.size.width  *= scale;
    cropRect.size.height *= scale;
    return [CIFilter filterWithName:@"CICrop"
                      keysAndValues:
            @"inputImage", inputImage,
            @"inputRectangle", [CIVector vectorWithCGRect:cropRect],
            nil];
}

+ (UIImage *)uiimageFromCIImage:(CIImage *)ciimage scale:(CGFloat)scale context:(CIContext *)context
{
    CGImageRef cgimg = [context createCGImage:ciimage
                                     fromRect:[ciimage extent]];
    return [[UIImage alloc] initWithCGImage:cgimg
                                      scale:scale
                                orientation:UIImageOrientationUp];
}

- (void)resetBackground
{    
    // Get width of image view:
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(width, width);
    
    // Set up checkerboard:
    CIFilter *checkerFilter = [self.class checkerboardFilterForSize:size];
    CIImage *checkCIImage = [checkerFilter valueForKey:kCIOutputImageKey];
    
    // Scale:
    CGFloat scale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [UIScreen mainScreen].scale;
    }
    
    // Crop:
    CIFilter *cropFilter = [self.class cropFilterForSize:size
                                                   scale:scale
                                              inputImage:checkCIImage];
    
    // Context:
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Convert background image:
    self.image = [self.class uiimageFromCIImage:cropFilter.outputImage
                                          scale:scale
                                        context:context];
}

@end
