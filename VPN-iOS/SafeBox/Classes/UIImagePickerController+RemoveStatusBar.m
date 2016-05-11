//
//  UIImagePickerController+RemoveStatusBar.m
//  SafeBox
//
//  Created by 宋扬 on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "UIImagePickerController+RemoveStatusBar.h"

@implementation UIImagePickerController (RemoveStatusBar)

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}

@end
