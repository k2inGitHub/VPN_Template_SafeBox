//
//  PhotoMoveController.h
//  SafeBox
//
//  Created by 宋扬 on 14-3-21.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"

@protocol PhotoMoveControllerDelegate <NSObject>

- (NSMutableArray *)toUpdatePreviews;

- (NSMutableArray *)toUpdateFiles;

- (SBItem *)item;

- (void)flushPhotos;


@end

@interface PhotoMoveController : KTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SBItem *selItem;

@property (nonatomic, assign) id<PhotoMoveControllerDelegate> delegate;

- (id)initWithDelegate:(id<PhotoMoveControllerDelegate>)delegate;

@end
