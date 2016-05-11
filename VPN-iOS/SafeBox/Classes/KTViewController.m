//
//  KTViewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "KTViewController.h"
#import "SBConfig.h"

@interface KTViewController ()

@end

@implementation KTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //goto 横屏再说
        _winFrame = _winBounds = [UIScreen mainScreen].bounds;
        
        _winSize = _winFrame.size;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;
        //不透明的操作栏
        //self.modalPresentationCapturesStatusBarAppearance = NO;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
