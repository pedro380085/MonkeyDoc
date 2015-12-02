//
//  WrapperViewCell.h
//  InEvent
//
//  Created by Pedro Góes on 10/19/15.
//  Copyright © 2015 Pedro G√≥es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrapperViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *wrapper;

- (void)configureCell;

@end
