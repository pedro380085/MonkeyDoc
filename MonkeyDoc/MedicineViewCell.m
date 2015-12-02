//
//  MedicineViewCell.m
//  MonkeyDoc
//
//  Created by Pedro Góes on 30/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "MedicineViewCell.h"
#import "ColorThemeController.h"

@implementation MedicineViewCell

- (void)configureCell {
    [super configureCell];
    
    // Background color
    self.backgroundView.backgroundColor = [ColorThemeController tableViewCellBackgroundColor];
    
    // Hide overflow
    self.contentView.superview.clipsToBounds = YES;
    
    // Line
    [_line setBackgroundColor:[ColorThemeController tableViewCellBorderColor]];
}

@end
