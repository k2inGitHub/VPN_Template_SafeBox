//
//  PhotoViewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"
#import "SBTableViewCell.h"
#import "PhotoPreviewController.h"
#import "KKPasscodeLock.h"
#import "SBManualController.h"

@interface PhotoViewController : KTViewController<UITableViewDelegate, UITableViewDataSource, PhotoPreviewControllerDelegate, KKPasscodeViewControllerDelegate, SBManualControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

///选中的item
@property (nonatomic, strong) SBItem *selItem;

@property (nonatomic, strong) UINavigationController *passcodeNav;

- (void)deleteItemWithName:(NSString *)name;

- (void)updateItemWithName:(NSString *)name;

- (BOOL)addItemWithName:(NSString *)name;

- (SBItem *)itemWithName:(NSString *)name;

- (BOOL)renameItem:(SBItem *)item withName:(NSString *)name;

- (NSMutableArray *)allItems;

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController;


@end
