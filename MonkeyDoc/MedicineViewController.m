//
//  MedicineViewController.m
//  MonkeyDoc
//
//  Created by Pedro Góes on 12/08/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "MedicineViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorThemeController.h"
#import "UIViewController+Present.h"
#import "UIImageView+WebCache.h"
#import "ETFlatBarButtonItem.h"
#import "ODRefreshControl.h"
#import "MedicineViewCell.h"
#import "MedicineItemViewController.h"

@interface MedicineViewController () {
    ODRefreshControl *refreshControl;
    NSIndexPath *selectedPath;
    MedicineDataController *speakerController;
}

@end

@implementation MedicineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Medicines", nil);
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Search Bar
    _searchBar.barTintColor = [ColorThemeController tableViewCellSelectedBackgroundColor];
    _searchBar.placeholder = NSLocalizedString(@"Search Medicines", nil);
    
    // Table View
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [ColorThemeController tableViewCellBackgroundColor];
    
    // Refresh Control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshControl.tintColor = [ColorThemeController navigationBarBackgroundColor];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    // Data Controller
    speakerController = [[MedicineDataController alloc] init];
    speakerController.delegate = self;
    _tableView.delegate = speakerController;
    _tableView.dataSource = speakerController;
    
    // Load people
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Event Session
    [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil userInfo:@{@"type": @"enterprise"}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loader

- (void)loadDataPreloadingPreviousCache:(BOOL)preload {
//    [[[INMedicineAPIController alloc] initWithDelegate:self returnPreviousSave:preload] findAtEventWithCompanyName:@"any" withName:@"any" withEmail:@"any" withTelephone:@"any" withOrder:@"any"];
}

@end