//
//  MedicineItemViewController.h
//  MonkeyDoc
//
//  Created by Pedro Góes on 14/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "WrapperViewController.h"
#import "MedicineDataController.h"
@import MessageUI;

@class UIPlaceHolderTextView;

@interface MedicineItemViewController : WrapperViewController <UIGestureRecognizerDelegate, UISplitViewControllerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, MedicineDataControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSDictionary *medicineData;
@property (strong, nonatomic) NSArray *dosageData;

@end
