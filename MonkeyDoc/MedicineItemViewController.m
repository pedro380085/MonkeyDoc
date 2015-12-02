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
    
    if (_medicineData) {
        // Send to server
        AFHTTPRequestOperationManager *manager = [[[HTTPManager alloc] initWithPath:@"/api/user/friend/:id/delete"] manager];
        
        [self startLoadingView];
        
        // Post to server
        [manager POST:[[[ROOT_DOMAIN stringByAppendingString:@"/api/user/friend/"] stringByAppendingString:@"ddd"] stringByAppendingString:@"/delete"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
    return 1 + [medicineController numberOfSectionsInTableView:aTableView];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (_medicineData ? 1 : 0);
    } else {
        return [medicineController tableView:aTableView numberOfRowsInSection:section - 1];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (headerHeight == 0.0f ? 10.0f : headerHeight);
    } else {
        return [medicineController tableView:aTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
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
        self.title = [self.medicineData objectForKey:@"companyName"];
        
        // Social
        [cell.view setFitFrameToContentSize:YES];
        [cell.availableLabel setTitle:[self.medicineData objectForKey:@"telephone"] forState:UIControlStateNormal];
        
        cell.delegate = self;
        
        if (headerHeight != cell.view.contentSize.height) {
            headerHeight = cell.view.contentSize.height;
            [self.tableView reloadData];
        }
        
        return cell;
        
    } else {
        return [medicineController tableView:aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
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
