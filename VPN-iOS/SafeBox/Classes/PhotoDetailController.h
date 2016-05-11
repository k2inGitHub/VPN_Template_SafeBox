//
//  PhotoDetailController.h
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"

@interface PhotoDetailController : KTViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *views;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) int photoIndex;

@end
