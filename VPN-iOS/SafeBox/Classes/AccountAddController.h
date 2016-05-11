//
//  AccountAddController.h
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"

@interface AccountAddController : KTViewController<UIScrollViewDelegate>

///是否新增模式 否则是编辑模式
@property (nonatomic, assign) BOOL isAdd;

////编辑模式下是否正在编辑
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) BOOL keyboardIsShown;

//cx yx
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic, strong) NSMutableDictionary *curDict;

@property (nonatomic, strong) UIScrollView *scrollView;

@end
