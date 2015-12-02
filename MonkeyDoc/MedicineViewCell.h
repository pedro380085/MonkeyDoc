//
//  MedicineViewCell.h
//  MonkeyDoc
//
//  Created by Pedro Góes on 30/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrapperViewCell.h"

@interface MedicineViewCell : WrapperViewCell

@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *weekDay;
@property (strong, nonatomic) IBOutlet UILabel *hour;

@end
