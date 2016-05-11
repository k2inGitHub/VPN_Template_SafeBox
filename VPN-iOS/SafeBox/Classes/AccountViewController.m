//
//  AccountViewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountPreviewController.h"
#import "SBManager.h"

//#import "AppController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* tabImg = [UIImage imageNamed:@"tab_account"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Account", @"Account") image:tabImg tag:0];
        self.tabBarItem = tabItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.tabBarItem.title;

    self.tableView = [[UITableView alloc] initWithFrame:self.winFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)keyFromTitle:(NSString *)title
{
    if ([title isEqualToString:NSLocalizedString(@"Savings Card", @"Savings Card")]) {
        return @"cx";
    } else if ([title isEqualToString:NSLocalizedString(@"Credit Card", @"Credit Card")]){
        return @"xy";
    } else if ([title isEqualToString:NSLocalizedString(@"Mail", @"Mail")]) {
        return @"yx";
    } else if ([title isEqualToString:NSLocalizedString(@"Useful Websites", @"Useful Websites")]) {
        return @"wz";
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SimpleTableViewIdentifier = @"Account-Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableViewIdentifier];
    }
    
    NSString *imgUrl ;
    NSString *text;
    
    NSString *key;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            imgUrl = @"zh_cxk";
            text = NSLocalizedString(@"Savings Card", @"Savings Card");
            key = @"cx";
        } else {
            imgUrl = @"zh_xyk";
            text = NSLocalizedString(@"Credit Card", @"Credit Card");
            key = @"xy";
        }
    } else {
        if (indexPath.row == 0) {
            imgUrl = @"zh_yx";
            text = NSLocalizedString(@"Mail", @"Mail");
            key = @"yx";
        } else {
            imgUrl = @"zh_wz";
            text = NSLocalizedString(@"Useful Websites", @"Useful Websites");
            key = @"wz";
        }
    }
    
    NSString *pw = [[[SBManager sharedManaegr].accountDict objectForKey:key] objectForKey:@"pw"];
    
    cell.imageView.image = [UIImage imageNamed:![pw isEqualToString:@""] ? @"fileLock" : imgUrl];
    
    cell.textLabel.text = text;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Bank Card", @"Bank Card");
    } else {
        return NSLocalizedString(@"Useful Websites", @"Useful Websites");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[AppController shareInstance] hide];

    self.selType = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.selPassword = [[[SBManager sharedManaegr].accountDict objectForKey:[self keyFromTitle:_selType]] objectForKey:@"pw"];
    
    
    if (!_selPassword || [_selPassword isEqualToString:@""]) {
        AccountPreviewController *vc = [[AccountPreviewController alloc] init];
        vc.navigationItem.title = _selType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Please enter password", @"Please enter password") delegate:self tag:10 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:self.selPassword]) {
                AccountPreviewController *vc = [[AccountPreviewController alloc] init];
                vc.navigationItem.title = _selType;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Password incorrect", @"Password incorrect") message:NSLocalizedString(@"If you forgot the password, you can click lock icon on left to remove password by password-protect", @"If you forgot the password, you can click lock icon on left to remove password by password-protect") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
            }
        }
    }
}

@end
