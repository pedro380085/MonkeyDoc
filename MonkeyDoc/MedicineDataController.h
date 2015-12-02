//
//  MedicineDataController.h
//  MonkeyDoc
//
//  Created by Pedro Góes on 8/8/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MedicineDataControllerDelegate <NSObject>

@optional
- (UITableView *)tableView;

@end

@interface MedicineDataController : NSObject <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UIViewController<UINavigationControllerDelegate, MedicineDataControllerDelegate> *delegate;
@property (strong, nonatomic) NSArray *dosageData;

@end
