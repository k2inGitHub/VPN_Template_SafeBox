//
//  SBVideoViewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SBVideoViewController.h"
#import "SBItem.h"
#import "SBTableViewCell.h"
#import "VedioMoveController.h"
#import "HLService.h"
#import "AppDelegate.h"

@interface SBVideoViewController ()

@end

@implementation SBVideoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        UIImage* tabImg = [UIImage imageNamed:@"tb_video"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Videos", @"Videos") image:tabImg tag:0];
        self.tabBarItem = tabItem;
    
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (textField.text && ![textField.text isEqualToString:@""]) {
                //goto 新建文件夹
                
                [self addItemWithName:textField.text];
                
                [_tableView reloadData];
            }
        }
    } else if (alertView.tag == 10) {
        //请输入密码
        if (buttonIndex == 1) {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:self.selItem.password]) {
                VedioPreviewController *vc = [[VedioPreviewController alloc] initWithDelegate:self];
                vc.navigationItem.title = self.selItem.name;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Password incorrect", @"Password incorrect") message:NSLocalizedString(@"If you forgot the password, you can click lock icon on left to remove password by password-protect", @"If you forgot the password, you can click lock icon on left to remove password by password-protect") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
            }
        }
    }
}

- (SBItem *)itemWithName:(NSString *)name
{
    SBItem *retItem = nil;
    for (int i = 0; i < _dataArray.count; i++) {
        SBItem *item = [_dataArray objectAtIndex:i];
        if ([item.name isEqualToString:name]) {
            retItem = item;
            break;
        }
    }
    return retItem;
}

- (NSMutableArray *)allItems
{
    return _dataArray;
}

- (void)deleteItemWithName:(NSString *)name
{
    NSInteger index = [_dataArray indexOfObject:[self itemWithName:name]];
    if (NSNotFound == index) {
        NSLog(@"没找到");
        return;
    }
    [self deleteItemWithIndex:index];
}

//删除一项
- (void)deleteItemWithIndex:(int)index
{
    [_dataArray removeObjectAtIndex:index];
    [self flushPhotos];
}

//存在 Yes
- (BOOL)IsItemExit:(NSString *)name
{
    for (int i = 0; i < _dataArray.count; i++) {
        SBItem *item = [_dataArray objectAtIndex:i];
        if ([item.name isEqualToString:name]) {
            [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Create Failed", @"Create Failed") message:NSLocalizedString(@"Folder already exits", @"Folder already exits") delegate:nil tag:10 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            return YES;
        }
    }
    return NO;
}

- (BOOL)renameItem:(SBItem *)item withName:(NSString *)name
{
    if ([self IsItemExit:name]) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    //图片改名
    for (int i = 0; i < item.files.count; i++) {
        NSString *file = [item.files objectAtIndex:i];
        NSString *dir = [file stringByDeletingLastPathComponent];
        NSString *last = [file lastPathComponent];
        last = [last substringFromIndex:name.length];
        NSLog(@"尾部 = %@", last);
        last = [name stringByAppendingString:last];
        NSLog(@"ret = %@", last);
        
        
        NSString *newFile = [dir stringByAppendingPathComponent:last];
        [item.files replaceObjectAtIndex:i withObject:newFile];
        
        if ([fm moveItemAtPath:file toPath:newFile error:&error] != YES)
            NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    //plist改名
    
    item.name = name;
    [self flushPhotos];
    
    
    NSLog(@"renameItem");
    
    NSLog(@"_dataArray = %@", _dataArray);
    
    return YES;
}

//更新一项
- (void)updateItemWithName:(NSString *)name
{
    [self flushPhotos];
}

//新增一项
- (BOOL)addItemWithName:(NSString *)name
{
    if ([self IsItemExit:name]) {
        return NO;
    }
    
    SBItem *item = [[SBItem alloc] init];
    item.name = name;
    item.type = 1;
    [_dataArray addObject:item];
    [self flushPhotos];
    NSLog(@"addItemWithName");
    NSLog(@"_dataArray = %@", _dataArray);
    return YES;
}

- (void)bbiAction:(UIBarButtonItem *)item
{
    if (item.tag == 0) {
        //增加
        [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Input the new folder name", @"Input the new folder name") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
    } else {
        //编辑
        [_tableView setEditing:!_tableView.editing animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)flushPhotos
{
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:SBVedioArchiveFile];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.tabBarItem.title;

    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"Add") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    left.tag = 0;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    right.tag = 10;
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;

    self.tableView = [[UITableView alloc] initWithFrame:self.winFrame style: UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:SBVedioArchiveFile]];
    
    [self cleanList];
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"market_reviwed_status"]==1){
        [self addList];
    }
}

- (void)cleanList
{
    for(int i=0; i<11; i++){
        NSString* name = [NSString stringWithFormat:@"girl%d",i];
        SBItem* item = [self itemWithName:name];
        if(item){
            [self.dataArray removeObject:item];
        }
    }
    
}

- (void)addList
{
    for(int i=10; i>=0; i--){
        NSString* name = [NSString stringWithFormat:@"girl%d",i];
        [self addItem:name];
    }
}

- (void)addItem:(NSString *)name
{
    SBItem *item = [[SBItem alloc] init];
    item.name = name;
    item.type = 0;
    item.full = 1;
    [self.dataArray insertObject:item atIndex:0];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SimpleTableViewIdentifier = @"Vedio-Cell";
    SBTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewIdentifier];
    if (cell == nil) {
        cell = [[SBTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableViewIdentifier];
    }
    
    SBItem *m = [_dataArray objectAtIndex:indexPath.row];
    
    cell.title.text = m.name;
    cell.subTitle.text = [NSString stringWithFormat:@"%d %@", m.files.count, NSLocalizedString(@"Videos", @"Videos")];
    
    if ([m.name isEqualToString:@"girl0"]) {cell.title.text = @"美女"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 1452, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl1"]) {cell.title.text = @"小清新"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 5652, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl2"]) {cell.title.text = @"性感"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 15878, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl3"]) {cell.title.text = @"写真"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 58566, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl4"]) {cell.title.text = @"宅男女神"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 55447, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl5"]) {cell.title.text = @"唯美"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 6668, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl6"]) {cell.title.text = @"快到碗里来"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 2112, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl7"]) {cell.title.text = @"气质"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 5688, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl8"]) {cell.title.text = @"嫩萝莉"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 45661, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl9"]) {cell.title.text = @"F90美女天团"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 44488, NSLocalizedString(@"Videos", @"Videos")];}
        if ([m.name isEqualToString:@"girl10"]) {cell.title.text = @"西洋美人"; cell.subTitle.text = [NSString stringWithFormat:@"%d %@", 5684, NSLocalizedString(@"Videos", @"Videos")];}
    
    NSString *imgUrl = (m.password == nil) ? @"zh_sps" : @"fileLock" ;
    cell.icon.image = [UIImage imageNamed:imgUrl];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[AppController shareInstance] hide];

    SBItem *item = [_dataArray objectAtIndex:indexPath.row];
    self.selItem = item;
    
    
    if(item.full==1){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ShowFullScreen"];
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
        return;
    }
    
    if (item.password) {
        [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"please enter password", @"please enter password") delegate:self tag:10 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
    } else {
        VedioPreviewController *vc = [[VedioPreviewController alloc] initWithDelegate:self];
        vc.navigationItem.title = item.name;
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteItemWithIndex:indexPath.row];
        
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        //goto
        [_dataArray insertObject:@"new Item" atIndex:indexPath.row];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
