//
//  ShopViewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* tabImg = [UIImage imageNamed:@"tb_shopping"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:@"商店" image:tabImg tag:0];
        self.tabBarItem = tabItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.tabBarItem.title;


}

@end
