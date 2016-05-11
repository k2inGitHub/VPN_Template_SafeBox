//
//  SettingViewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SettingViewController.h"
#import "SBManualController.h"
#import "SettingDetailController.h"
//#import "UMFeedback.h"
//#import "KTComponentIOS.h"

#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* tabImg = [UIImage imageNamed:@"tb_settings"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Setting", @"Setting") image:tabImg tag:0];
        self.tabBarItem = tabItem;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.tabBarItem.title;
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    [self.dataArray addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Modify Login Password", @"Modify Login Password"), /*NSLocalizedString(@"Suggestion Feedback",@"Suggestion Feedback"),*/ NSLocalizedString(@"Using Manual", @"Using Manual"), NSLocalizedString(@"About Info", @"About Info"), nil]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SimpleTableViewIdentifier = @"Setting-Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableViewIdentifier];
    }
    
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    float width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320;
    
    UILabel *label = [KTUIFactory customLabelWithFrame:CGRectMake(5, 42, width, 2) text:[KTUIFactory stringForTableViewDotLine] textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:6 textAlignment:UITextAlignmentLeft];
    [cell.contentView addSubview:label];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[AppController shareInstance] hide];

    NSString *str = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        SettingDetailController *vc = [[SettingDetailController alloc] init];
        vc.name = str;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (indexPath.row == 1) {
        //goto
//        [UMFeedback showFeedback:self withAppkey:[KTComponentIOS sharedComponent].umengKey];
//    }
    else if (indexPath.row == 1) {
        SBManualController *vc = [[SBManualController alloc] initWithDelegate:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        SettingDetailController *vc = [[SettingDetailController alloc] init];
        vc.name = str;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
