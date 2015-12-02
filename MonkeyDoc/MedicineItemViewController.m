//
//  MedicineItemViewController.m
//  MonkeyDoc
//
//  Created by Pedro Góes on 14/10/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MedicineItemViewController.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"
#import "UIViewController+Present.h"
#import "UIViewController+Loading.h"
#import "UIButton+Configuration.h"
#import "MedicineItemHeaderViewCell.h"
#import "MedicineDataController.h"
#import "HTTPManager.h"
#import "PersonToken.h"
#import "MedicineViewCell.h"

@interface MedicineItemViewController () {
    ODRefreshControl *refreshControl;
    BOOL editingMode;
    NSString *baseMessage;
    CGFloat headerHeight;
    MedicineDataController *medicineController;
}

@end

@implementation MedicineItemViewController

@dynamic view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization
    }
    return self;
}

#pragma mark - View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Refresh Control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshControl.tintColor = [ColorThemeController navigationBarBackgroundColor];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    // Data Controller
    medicineController = [[MedicineDataController alloc] init];
    medicineController.delegate = self;
    
    // Prepare screen
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Paint
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter Methods

- (void)setMedicineData:(NSDictionary *)medicineData {
    _medicineData = medicineData;
    
    [self.tableView reloadData];
    [self loadData];
}

#pragma mark - Loader

- (void)loadDataPreloadingPreviousCache:(BOOL)preload {
    
    _medicineData = @{@"picture" : @"http://people.opposingviews.com/DM-Resize/photos.demandstudios.com/getty/article/117/132/87753812.jpg?w=600&h=600&keep_ratio=1", @"name" : @"Lidocaine", @"available" : @"3"};
    _dosageData = @[@{@"weekDay" : @"Monday", @"hour" : @"10h"},
                    @{@"weekDay" : @"Tuesday", @"hour" : @"10h"},
                    @{@"weekDay" : @"Tuesday", @"hour" : @"12h"},
                    @{@"weekDay" : @"Tuesday", @"hour" : @"14h"}
                    ];
    
    [self stopLoadingView];
    [refreshControl endRefreshing];
    
    [self.tableView reloadData];
    
    return;
    
    if (_medicineData) {
        // Send to server
        AFHTTPRequestOperationManager *manager = [[[HTTPManager alloc] init] manager];
        
        [self startLoadingView];
        
        NSDictionary *params = @{@"access_token" : [[PersonToken sharedInstance] objectForKey:@"tokenID"]};
        
        // Post to server
        [manager GET:[ROOT_DOMAIN stringByAppendingString:@"/user/prescriptions"]  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self stopLoadingView];
            
            // Reload our data
            [self reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self stopLoadingView];
            
            // Show message
            ETAlertView *alertView = [[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:NSLocalizedString(@"Person is too powerful, friend cannot be removed!", nil) confirmationButtonTitle:@"ok!"];
            [alertView show];
        }];
    }
}

#pragma mark - Bar Methods

- (void)loadDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (_medicineData ? 1 : 0);
    } else {
        return [_dosageData count];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (headerHeight == 0.0f ? 10.0f : headerHeight);
    } else {
        return 72.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *CustomCellIdentifier = @"MedicineItemHeaderViewCell";
        MedicineItemHeaderViewCell *cell = (MedicineItemHeaderViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (cell == nil) {
            [aTableView registerNib:[UINib nibWithNibName:@"MedicineItemHeaderViewCell" bundle:nil] forCellReuseIdentifier:CustomCellIdentifier];
            cell = (MedicineItemHeaderViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier forIndexPath:indexPath];
        }
        
        // Photo
        [cell.photo sd_setImageWithURL:[self.medicineData objectForKey:@"picture"]];
        
        // Title
        self.title = [self.medicineData objectForKey:@"name"];
        
        // Social
        [cell.view setFitFrameToContentSize:YES];
        [cell.availableLabel setTitle:[NSString stringWithFormat:@"%@ left", [self.medicineData objectForKey:@"available"]] forState:UIControlStateNormal];
        
        cell.delegate = self;
        
        if (headerHeight != cell.view.contentSize.height) {
            headerHeight = cell.view.contentSize.height;
            [self.tableView reloadData];
        }
        
        return cell;
        
    } else {
        
        static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
        MedicineViewCell *cell = (MedicineViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (cell == nil) {
            [aTableView registerNib:[UINib nibWithNibName:@"MedicineViewCell" bundle:nil] forCellReuseIdentifier:CustomCellIdentifier];
            cell = (MedicineViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        }
        
        NSDictionary *dictionary = [self.dosageData objectAtIndex:indexPath.row];
        
        cell.weekDay.text = [dictionary objectForKey:@"weekDay"];
        cell.hour.text = [dictionary objectForKey:@"hour"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        [medicineController tableView:aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
    }
    
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (editingMode) {
        return [super textFieldShouldBeginEditing:textField];
    } else {
        return NO;
    }
}

#pragma mark - Mail Composer Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
