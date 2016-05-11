//
//  VedioMoveController.h
//  SafeBox
//
//  Created by 宋扬 on 14-3-21.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"

@protocol VedioMoveControllerDelegate <NSObject>

- (NSMutableArray *)toUpdatePreviews;

- (NSMutableArray *)toUpdateFiles;

- (SBItem *)item;

- (void)flushPhotos;


@end

@interface VedioMoveController : KTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SBItem *selItem;

@property (nonatomic, assign) id<VedioMoveControllerDelegate> delegate;

- (id)initWithDelegate:(id<VedioMoveControllerDelegate>)delegate;

@end
