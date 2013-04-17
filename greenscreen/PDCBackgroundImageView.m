//
//  PDCBackgroundImageView.m
//  greenscreen
//
//  Created by koba on 4/16/13.
//  Copyright (c) 2013 Pas de Chocolat. All rights reserved.
//

#import "PDCBackgroundImageView.h"


@implementation PDCBackgroundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)resetBackground
{
    // Context:
    CIContext *ctx = [CIContext contextWithOptions:nil];
    
    // Get width of image view:
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // Set up checkerboard:
    NSNumber *twoSquareWidth = @(8);
    CIFilter *checkerFilter = [CIFilter filterWithName:@"CICheckerboardGenerator"
                                         keysAndValues:
                               @"inputColor0", [CIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f],
                               @"inputColor1", [CIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f],
                               @"inputWidth", twoSquareWidth,
                               @"inputCenter", [CIVector vectorWithX:width/2.0f Y:width/2.0f],
                               nil];
    CIImage *checkCIImage = [checkerFilter valueForKey:kCIOutputImageKey];
    
    // Scale:
    CGFloat scale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [UIScreen mainScreen].scale;
    }
    
    // Crop:
    CGRect cropRect = CGRectZero;
    cropRect.size = CGSizeMake(width, width);
    cropRect.size.width  *= scale;
    cropRect.size.height *= scale;
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"
                                      keysAndValues:
                            @"inputImage", checkCIImage,
                            @"inputRectangle", [CIVector vectorWithCGRect:cropRect],
                            nil];
    
    // Convert background image:
    CIImage *ciimage = cropFilter.outputImage;
    CGImageRef cgimg = [ctx createCGImage:ciimage
                                 fromRect:[ciimage extent]];
    self.image = [[UIImage alloc] initWithCGImage:cgimg
                                            scale:scale
                                      orientation:UIImageOrientationUp];
}

@end
