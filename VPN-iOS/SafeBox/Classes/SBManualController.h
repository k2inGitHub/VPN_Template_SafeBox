//
//  SBManualController.h
//  SafeBox
//
//  Created by SongYang on 14-3-21.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"

@protocol SBManualControllerDelegate <NSObject>

- (void)manualDidClose;

@end

@interface SBManualController : KTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SBManualControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

- (id)initWithDelegate:(id<SBManualControllerDelegate>)delegate;

@end
