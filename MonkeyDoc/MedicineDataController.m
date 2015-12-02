//
//  MedicineDataController.m
//  MonkeyDoc
//
//  Created by Pedro Góes on 8/8/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "MedicineDataController.h"
#import "MedicineViewCell.h"
#import "MedicineItemViewController.h"
#import "UIScrollView+EmptyState.h"

@implementation MedicineDataController {
    NSArray *filteredData;
}

#pragma mark - Private Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName CONTAINS[cd] %@ OR email CONTAINS[cd] %@ OR website CONTAINS[cd] %@", searchText, searchText, searchText];
    filteredData = [self.dosageData filteredArrayUsingPredicate:predicate];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_delegate.tableView emptyStateForImageNamed:@"Medicines" withTitle:NSLocalizedString(@"Medicines", nil) withDescription:NSLocalizedString(@"We still do not have a list of Medicines, as soon as they are added you will be notified.", nil) forArray:self.dosageData inSection:section];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    MedicineViewCell *cell = (MedicineViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell == nil) {
        [aTableView registerNib:[UINib nibWithNibName:@"MedicineViewCell" bundle:nil] forCellReuseIdentifier:CustomCellIdentifier];
        cell = (MedicineViewCell *)[aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    }
    
    NSDictionary *dictionary = [self.dosageData objectAtIndex:indexPath.row];
    
    cell.weekDay.text = [dictionary objectForKey:@"companyName"];
    cell.hour.text = [dictionary objectForKey:@"website"];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MedicineItemViewController *vc;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        vc = [[MedicineItemViewController alloc] initWithNibName:@"MedicineItemViewController" bundle:nil];
    } else {
        // Find the sibling navigation controller first child and send the appropriate data
        vc = (MedicineItemViewController *)[[[self.delegate.splitViewController.viewControllers lastObject] viewControllers] objectAtIndex:0];
    }
    
    NSDictionary *dictionary = [self.dosageData objectAtIndex:indexPath.row];
    
    [vc setTitle:[dictionary objectForKey:@"companyName"]];
    [vc setMedicineData:dictionary];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.delegate.navigationController pushViewController:vc animated:YES];
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:[[self.delegate.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.delegate.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.delegate.searchDisplayController.searchBar.text scope:[[self.delegate.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
