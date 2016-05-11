//
//  KTViewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTUIFactory.h"
#import "SBConfig.h"
#import "NSData+KTAdditional.h"
#import "SBManager.h"
#import "SBItem.h"
//#import "KTComponentIOS.h"


@interface KTViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, assign) CGRect winBounds;

@property (nonatomic, assign) CGSize winSize;

@property (nonatomic, assign) CGRect winFrame;


@end
