//
//  MedicineItemHeaderViewCell.h
//  MonkeyDoc
//
//  Created by Pedro Góes on 8/8/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "WrapperViewCell.h"
#import "ETFlowView.h"

@class UIPlaceHolderTextView;
@class MedicineItemViewController;

@interface MedicineItemHeaderViewCell : WrapperViewCell

@property (nonatomic, strong) IBOutlet ETFlowView *view;

@property (nonatomic, strong) IBOutlet UIImageView *photo;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;

@property (nonatomic, strong) IBOutlet UILabel *generalLabel;
@property (nonatomic, strong) IBOutlet UIButton *telephoneLabel;
@property (nonatomic, strong) IBOutlet UIButton *emailLabel;
@property (nonatomic, strong) IBOutlet UIButton *websiteLabel;

@property (nonatomic, strong) IBOutlet UILabel *aboutLabel;
@property (nonatomic, strong) IBOutlet UIPlaceHolderTextView *descript;

@property (strong, nonatomic) MedicineItemViewController *delegate;

@end
