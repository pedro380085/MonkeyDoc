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
#import "UITextView+Configuration.h"
#import "UIPlaceHolderTextView.h"
#import "MedicineItemViewController.h"
#import "JTSImageViewController.h"
#import "NSDictionary+Avatar.h"
#import "UILabel+Configuration.h"

@implementation MedicineItemHeaderViewCell

- (void)configureCell {
    [super configureCell];
    
    // View
    self.view.scrollEnabled = NO;
    
    // Wrapper
    [self.wrapper setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
    
    // Photo
    [_photo.layer setMasksToBounds:YES];
    
    // Text Views
    [_descript configureTextView];
    
    // Labels
    [_generalLabel setText:NSLocalizedString(@"GENERAL INFORMATION", nil)];
    [_generalLabel configureHighlightedLabel];
    [_aboutLabel setText:NSLocalizedString(@"ABOUT", nil)];
    [_aboutLabel configureHighlightedLabel];
    
//    _wrapper.backgroundColor = [UIColor purpleColor];
//    self.view.backgroundColor = [UIColor redColor];
//    _descript.backgroundColor = [UIColor blueColor];
}

#pragma mark - Action Methods

- (IBAction)displayProfileImage:(id)sender {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [_delegate.MedicineData avatarImageURLForSize:CGSizeMake(640.0f, 640.0f)];
    imageInfo.referenceRect = self.view.frame;
    imageInfo.referenceView = self.view;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:_delegate transition:JTSImageViewControllerTransition_FromOffscreen];
}

- (IBAction)loadTelephone:(id)sender {
    NSString *telephoneNumber = [[[_delegate.MedicineData objectForKey:@"telephone"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789+"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", telephoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        [[UIApplication sharedApplication] openURL:telURL];
    } else {
        [[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil) message:NSLocalizedString(@"This device doesn't appear to be a phone.", nil) confirmationButtonTitle:@"Ok"] show];
    }
}

- (IBAction)loadEmail:(id)sender {
    NSURL *emailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", [_delegate.MedicineData objectForKey:@"email"]]];
    [[UIApplication sharedApplication] openURL:emailURL];
}

- (IBAction)loadWebView:(id)sender {
    UIViewController *viewController = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_delegate.MedicineData objectForKey:@"website"]]]];
    [viewController.view addSubview:webView];
    
    [_delegate.navigationController pushViewController:viewController animated:YES];
}

@end