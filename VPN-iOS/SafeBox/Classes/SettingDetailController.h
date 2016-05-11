//
//  SettingDetailController.h
//  SafeBox
//
//  Created by SongYang on 14-3-24.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"

@interface SettingDetailController : KTViewController<UITextFieldDelegate>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *texts;

@end
