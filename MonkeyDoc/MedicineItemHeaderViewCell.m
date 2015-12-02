//
//  MedicineItemHeaderViewCell.m
//  MonkeyDoc
//
//  Created by Pedro Góes on 8/8/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "MedicineItemHeaderViewCell.h"
#import "ColorThemeController.h"
#import "UIButton+Configuration.h"
#import "MedicineItemViewController.h"
#import "UILabel+Configuration.h"
#import "JTSImageViewController.h"
#import "SIMProductViewController.h"

@implementation MedicineItemHeaderViewCell

- (void)configureCell {
    [super configureCell];
    
    // View
    self.view.scrollEnabled = NO;
    
    // Wrapper
    [self.wrapper setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
    
    // Photo
    [_photo.layer setMasksToBounds:YES];
    
    _buyButton.layer.cornerRadius = 44.0f;
    
    // Labels
    [_generalLabel setText:NSLocalizedString(@"GENERAL INFORMATION", nil)];
    [_generalLabel configureHighlightedLabel];
    
//    _wrapper.backgroundColor = [UIColor purpleColor];
//    self.view.backgroundColor = [UIColor redColor];
//    _descript.backgroundColor = [UIColor blueColor];
}

#pragma mark - Action Methods

- (IBAction)displayProfileImage:(id)sender {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:[_delegate.medicineData objectForKey:@"picture"]];
    imageInfo.referenceRect = self.view.frame;
    imageInfo.referenceView = self.view;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:_delegate transition:JTSImageViewControllerTransition_FromOffscreen];
}

- (IBAction)pushToPass:(id)sender {
    SIMProductViewController *sim = [[SIMProductViewController alloc] initWithNibName:nil bundle:nil];
    [_delegate.navigationController pushViewController:sim animated:YES];
}

@end