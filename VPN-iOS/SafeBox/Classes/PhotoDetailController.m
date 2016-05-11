//
//  PhotoDetailController.m
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "PhotoDetailController.h"

@interface PhotoDetailController ()

@end

@implementation PhotoDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)bbiAction:(UIBarButtonItem *)item
{
    if (item.tag == 10) {
        [KTUIFactory showAlertViewWithTitle:@"设为登陆图片" message:@"您确定设置本照片为登陆页背景图片么" delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            //goto
        }
    }
}

- (void)tapAction
{
    BOOL lastHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!lastHidden animated:NO];
    
    for (int i = 0; i < self.photos.count; i++) {
        
        UIScrollView *sw = [_views objectAtIndex:i];
        
        sw.center = CGPointMake(self.winSize.width*(i+0.5), sw.center.y + (lastHidden?-44:44));
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"1/%d", self.photos.count];
    self.view.backgroundColor = [UIColor blackColor];
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"设为登陆图片" style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
//    right.tag = 10;
//    self.navigationItem.rightBarButtonItem = right;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.winFrame];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photos.count, self.view.frame.size.height);
    [scrollView setContentOffset:CGPointMake(self.winSize.width * _photoIndex, 0) animated:NO];
    self.views = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
    
    for (int i = 0; i < self.photos.count; i++) {
        
        UIScrollView *sw = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
        [scrollView addSubview:sw];
        sw.center = CGPointMake(self.winSize.width*(i+0.5), sw.center.y);
        UIImage *image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:[self.photos objectAtIndex:i]] scaleToSize:sw.frame.size];
        UIImageView *iw = [[UIImageView alloc] initWithImage:image];
        [sw addSubview:iw];
        [_views addObject:sw];
    }
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tgr];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _photoIndex = scrollView.contentOffset.x / self.winSize.width;
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", _photoIndex+1, _photos.count];
}

@end
