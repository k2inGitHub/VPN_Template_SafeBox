//
//  SBVideoViewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"
#import "VedioPreviewController.h"

@interface SBVideoViewController : KTViewController<UITableViewDelegate, UITableViewDataSource, VedioPreviewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

///选中的item
@property (nonatomic, strong) SBItem *selItem;

- (void)deleteItemWithName:(NSString *)name;

- (void)updateItemWithName:(NSString *)name;

- (BOOL)addItemWithName:(NSString *)name;

- (SBItem *)itemWithName:(NSString *)name;

- (BOOL)renameItem:(SBItem *)item withName:(NSString *)name;

- (NSMutableArray *)allItems;


@end
