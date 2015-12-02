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
#import "UIButton+Configuration.h"
#import "MedicineItemHeaderViewCell.h"

@interface MedicineItemViewController () {
    ODRefreshControl *refreshControl;
    BOOL editingMode;
    NSString *baseMessage;
    CGFloat headerHeight;
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
    scheduleController = [[AgendaDataController alloc] init];
    scheduleController.delegate = self;
    scheduleController.displayAsList = YES;
    
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

- (void)setMedicineData:(NSDictionary *)MedicineData {
    _MedicineData = MedicineData;
    
    [self.tableView reloadData];
    [self loadData];
}

#pragma mark - Loader

- (void)loadDataPreloadingPreviousCache:(BOOL)preload {
    
    if (_MedicineData) {
        [[[INMedicineAPIController alloc] initWithDelegate:self returnPreviousSave:preload] getAtMedicine:[[_MedicineData objectForKey:@"MedicineID"] integerValue]];
    }
}

#pragma mark - Bar Methods

- (void)loadDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1 + [scheduleController numberOfSectionsInTableView:aTableView];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (_MedicineData ? 1 : 0);
    } else {
        return [scheduleController tableView:aTableView numberOfRowsInSection:section - 1];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (headerHeight == 0.0f ? 10.0f : headerHeight);
    } else {
        return [scheduleController tableView:aTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
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
        [cell.photo loadProfileImageForDictionary:_MedicineData withRoundedLayout:NO];
        
        // Title
        self.title = [[_MedicineData objectForKey:@"companyName"] stringByDecodingHTMLEntities];
        
        // Social
        [cell.view setFitFrameToContentSize:YES];
        [cell.telephoneLabel setTitle:[_MedicineData objectForKey:@"telephone"] forState:UIControlStateNormal];
        [cell.emailLabel setTitle:[_MedicineData objectForKey:@"email"] forState:UIControlStateNormal];
        [cell.websiteLabel setTitle:[_MedicineData objectForKey:@"website"] forState:UIControlStateNormal];
        [cell.view toggleFrameForWrapperOfView:cell.telephoneLabel basedOnText:[_MedicineData objectForKey:@"telephone"]];
        [cell.view toggleFrameForWrapperOfView:cell.emailLabel basedOnText:[_MedicineData objectForKey:@"email"]];
        [cell.view toggleFrameForWrapperOfView:cell.websiteLabel basedOnText:[_MedicineData objectForKey:@"website"]];
        
        // Description
        [cell.view resizeAndSetAttributedText:[NSAttributedString attributedStringFromHTML:[[_MedicineData objectForKey:@"bio"] stringByDecodingHTMLEntities] normalFont:cell.descript.font boldFont:[UIFont systemFontOfSize:cell.descript.font.pointSize] italicFont:[UIFont italicSystemFontOfSize:cell.descript.font.pointSize]] forTextInput:cell.descript withMinimumHeight:32.0f];
        
        cell.delegate = self;
        
        if (headerHeight != cell.view.contentSize.height) {
            headerHeight = cell.view.contentSize.height;
            [self.tableView reloadData];
        }
        
        return cell;
        
    } else {
        return [scheduleController tableView:aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        [scheduleController tableView:aTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)]];
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
