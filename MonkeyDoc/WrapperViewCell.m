//
//  WrapperViewCell.m
//  InEvent
//
//  Created by Pedro Góes on 10/19/15.
//  Copyright © 2015 Pedro G√≥es. All rights reserved.
//

#import "WrapperViewCell.h"
#import "ColorThemeController.h"

@implementation WrapperViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureCell];
}

- (void)configureCell {
    
    // We can define the background view and its color
    [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.backgroundView setBackgroundColor:[ColorThemeController backgroundColor]];
    [self setSelectedBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.selectedBackgroundView setBackgroundColor:[ColorThemeController backgroundColor]];
    
    // Wrapper
    [_wrapper setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [self setActiveWrapperBackgroundColor:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the selected state
    [self setActiveWrapperBackgroundColor:highlighted];
}

#pragma mark - Private Methods

- (void)setActiveWrapperBackgroundColor:(BOOL)active {
    if ([[_wrapper backgroundColor] isEqual:[ColorThemeController tableViewCellSelectedBackgroundColor]] || [[_wrapper backgroundColor] isEqual:[ColorThemeController tableViewCellBackgroundColor]]) {
        if (active) {
            [_wrapper setBackgroundColor:[ColorThemeController tableViewCellSelectedBackgroundColor]];
        } else {
            [_wrapper setBackgroundColor:[ColorThemeController tableViewCellBackgroundColor]];
        }
    }
}

@end
