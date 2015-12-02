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
#import "UIViewController+Loading.h"
#import "UIImageView+WebCache.h"
#import "ETFlatBarButtonItem.h"
#import "ODRefreshControl.h"
#import "MedicineViewCell.h"
#import "MedicineItemViewController.h"
#import "HTTPManager.h"
#import "PersonToken.h"

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
    
    self.title = NSLocalizedString(@"Medicines", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loader

- (void)loadDataPreloadingPreviousCache:(BOOL)preload {
    
    // Send to server
    AFHTTPRequestOperationManager *manager = [[[HTTPManager alloc] init] manager];
    
//    [self startLoadingView];
    
    NSDictionary *params = @{@"access_token" : [[PersonToken sharedInstance] objectForKey:@"tokenID"]};
    
    speakerController.dosageData = @[@{@"picture" : @"http://people.opposingviews.com/DM-Resize/photos.demandstudios.com/getty/article/117/132/87753812.jpg?w=600&h=600&keep_ratio=1", @"name" : @"Lidocaine"},
                                     
            @{@"picture" : @"http://changinghabits.com.au/blogs/medicine.jpg", @"name" : @"Oraquick"},
  @{@"picture" : @"http://www.3ders.org/images2014/%E2%80%8Bpharmaceutical-researcher-create-new-shapes-medicine-tablets-3d-printing-00005.jpg", @"name" : @"Aveeno"},
                                     
                                     
                                     @{@"picture" : @"http://www.cvs.com/bizcontent/merchandising/productimages/large/30573016949.jpg", @"name" : @"Advil"}];
    
    [self stopLoadingView];
    [refreshControl endRefreshing];
    
    [_tableView reloadData];
    
    return;
    
    // Post to server
    [manager POST:[ROOT_DOMAIN stringByAppendingString:@"/user/medicines"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self stopLoadingView];
        
        // Reload our data
        speakerController.dosageData = responseObject;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self stopLoadingView];
        
        // Show message
        ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:NSLocalizedString(@"Person is too powerful, friend cannot be removed!", nil) confirmationButtonTitle:@"ok!"];
        [alertView show];
    }];
}

@end
