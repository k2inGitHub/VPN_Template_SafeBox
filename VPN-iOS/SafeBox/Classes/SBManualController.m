//
//  SBManualController.m
//  SafeBox
//
//  Created by SongYang on 14-3-21.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SBManualController.h"




@interface SBManualController ()

@end

@implementation SBManualController

- (id)initWithDelegate:(id<SBManualControllerDelegate>)delegate
{
    if (self = [super init]) {
        
        _delegate = delegate;
        
    }
    return self;
}

- (void)bbiAction:(UIBarButtonItem *)item
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [_delegate manualDidClose];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = NSLocalizedString(@"Using Manual", @"Using Manual");
    
    if (_delegate){
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
        self.navigationItem.leftBarButtonItem = left;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    NSString *file = [[KTUIFactory getPreferredLanguage] isEqualToString:@"zh-Hans"] ? @"manual.plist" : @"manual_en.plist";
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:[BundlePath stringByAppendingPathComponent:file]]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"PASSWORD RELATED", @"PASSWORD RELATED");
    } else if (section == 1) {
        return NSLocalizedString(@"PHOTOS AND VIDEOS", @"PHOTOS AND VIDEOS");
    } else {
        return NSLocalizedString(@"OTHERS", @"OTHERS");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // 列寬
    CGFloat contentWidth = self.tableView.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    
    // 該行要顯示的內容
    NSString *content = [dict objectForKey:@"title"];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    // 這裏返回需要的高度
    
    // 列寬
    // 用何種字體進行顯示
    font = [UIFont systemFontOfSize:13];
    
    // 該行要顯示的內容
    content = [dict objectForKey:@"content"];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size2 = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    // 這裏返回需要的高度
    
    return size.height + size2.height + 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SimpleTableViewIdentifier = @"Photo-Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableViewIdentifier];
    }
    
    
    NSDictionary *dict = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // 列寬
    CGFloat contentWidth = self.tableView.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    
    // 該行要顯示的內容
    NSString *content = [dict objectForKey:@"title"];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    // 設置顯示榘形大小
    rect.size = CGSizeMake(size.width, size.height + 50);
    // 重置列文本區域
    cell.textLabel.frame = rect;
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.textLabel.text = content;
    
    // 設置自動換行(重要)
    cell.textLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    cell.textLabel.font = font;
    
    // 列寬
    contentWidth = self.tableView.frame.size.width;
    // 用何種字體進行顯示
   font = [UIFont systemFontOfSize:13];
    
    // 該行要顯示的內容
    content = [dict objectForKey:@"content"];
    // 計算出顯示完內容需要的最小尺寸
    size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    // 設置顯示榘形大小
    rect.size = CGSizeMake(size.width, size.height + 50);
    // 重置列文本區域
    cell.detailTextLabel.frame = rect;
    
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.detailTextLabel.text = content;
    
    // 設置自動換行(重要)
    cell.detailTextLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    cell.detailTextLabel.font = font;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
