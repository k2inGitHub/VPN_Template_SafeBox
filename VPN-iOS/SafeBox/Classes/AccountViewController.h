//
//  AccountViewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"

@interface AccountViewController : KTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *selPassword;

@property (nonatomic, copy) NSString *selType;

@end
