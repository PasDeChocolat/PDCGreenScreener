//
//  PDCViewController.h
//  greenscreen
//
//  Created by koba on 1/30/13.
//  Copyright (c) 2013 Pas de Chocolat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCGreenScreener.h"
#import "PDCBackgroundImageView.h"

@interface PDCViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PDCBackgroundImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UISlider *hueCenterSlider;
@property (weak, nonatomic) IBOutlet UISlider *hueRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *hueCenterLabel;
@property (weak, nonatomic) IBOutlet UILabel *hueRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;

@property (nonatomic, strong) PDCGreenScreener *greenScreener;
@property (nonatomic, strong) UIImage *originalImage;
@property (weak, nonatomic) IBOutlet UIView *hueView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hueUpdateSpinner;

- (IBAction)imageTapped:(id)sender;
- (IBAction)handleSelectPhotoPressed:(UIButton *)sender;
- (IBAction)hueCenterValueChanged:(UISlider *)sender;
- (IBAction)hueRangeValueChanged:(UISlider *)sender;

@end
