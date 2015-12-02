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
#import "HumanViewController.h"
#import "MedicineViewCell.h"
#import "MedicineItemViewController.h"
#import "CompanyMacro.h"

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
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [ColorThemeController tableViewBackgroundColor];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [ColorThemeController tableViewBackgroundColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    
    // Refresh Control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshControl.tintColor = [ColorThemeController navigationBarBackgroundColor];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    // Data Controller
    speakerController = [[MedicineDataController alloc] init];
    speakerController.delegate = self;
    _tableView.delegate = speakerController;
    _tableView.dataSource = speakerController;
    self.searchDisplayController.delegate = speakerController;
    self.searchDisplayController.searchResultsDataSource = speakerController;
    self.searchDisplayController.searchResultsDelegate = speakerController;
    
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
    
    [[INTrackingToken sharedInstance] addToQueueWithTarget:@"screen/Medicines" atTarget:[[[MonkeyDocToken sharedInstance] objectForKey:@"eventID"] integerValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loader

- (void)loadDataPreloadingPreviousCache:(BOOL)preload {
    [[[INMedicineAPIController alloc] initWithDelegate:self returnPreviousSave:preload] findAtEventWithCompanyName:@"any" withName:@"any" withEmail:@"any" withTelephone:@"any" withOrder:@"any"];
}

#pragma mark - APIController Delegate

- (void)apiController:(INAPIController *)apiController didLoadDictionaryFromServer:(NSDictionary *)dictionary {
    
    if ([apiController.method isEqualToString:@"find"]) {
        
        // Prepare our dictionary
        [speakerController setMedicineData:[dictionary objectForKey:@"data"]];
        
        // Reload all table data
        [self.tableView reloadData];
        
    }
    
    [refreshControl endRefreshing];
}

- (void)apiController:(INAPIController *)apiController didSaveForLaterWithError:(NSError *)error {
    [super apiController:apiController didSaveForLaterWithError:error];
    
    [refreshControl endRefreshing];
}

- (void)apiController:(INAPIController *)apiController didFailWithError:(NSError *)error {
    [super apiController:apiController didFailWithError:error];
    
    [refreshControl endRefreshing];
}

@end
