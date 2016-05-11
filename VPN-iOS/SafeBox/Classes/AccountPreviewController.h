//
//  AccountPreviewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"

@interface AccountPreviewController : KTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSMutableDictionary *accountDict;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIToolbar *toolBar;

@end
