//
//  MedicineViewController.h
//  MonkeyDoc
//
//  Created by Pedro Góes on 30/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "WrapperViewController.h"
#import "MedicineDataController.h"

@interface MedicineViewController : WrapperViewController <UIGestureRecognizerDelegate, UISplitViewControllerDelegate, UINavigationControllerDelegate, MedicineDataControllerDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
