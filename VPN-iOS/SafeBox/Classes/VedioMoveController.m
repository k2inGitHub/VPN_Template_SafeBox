//
//  VedioMoveController.m
//  SafeBox
//
//  Created by 宋扬 on 14-3-21.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "VedioMoveController.h"
#import "SBItem.h"


@interface VedioMoveController ()

@end

@implementation VedioMoveController

- (id)initWithDelegate:(id<VedioMoveControllerDelegate>)delegate
{
    if (self = [super init]) {
        
        _delegate = delegate;
        
    }
    return self;
}


- (void)bbiAction:(UIBarButtonItem *)item
{
    if (item.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        //goto
        if (_selItem) {
            
            for (int i = 0; i < [_delegate toUpdateFiles].count; i++) {
                NSString *src = [[_delegate toUpdateFiles] objectAtIndex:i];
                [_selItem addFileFromOther:src];
                [[_delegate item]removeFile:src];
            }
            
            [[_delegate toUpdateFiles] removeAllObjects];
            [[_delegate toUpdatePreviews] removeAllObjects];
            [_delegate flushPhotos];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Please select one folder", @"Please select one folder") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _selItem = nil;
    
    self.navigationItem.title = NSLocalizedString(@"Move videos", @"Move videos");

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    left.tag = 0;
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sure", @"Sure") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    right.tag = 10;
    self.navigationItem.rightBarButtonItem = right;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

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
    static NSString * SimpleTableViewIdentifier = @"Photo-Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableViewIdentifier];
    }
    
    SBItem *item = [_dataArray objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@", item.files.count, NSLocalizedString(@"Videos", @"Videos")];
    
    NSString *imgUrl = (item.password == nil) ? @"zh_phs" : @"fileLock" ;
    cell.imageView.image = [UIImage imageNamed:imgUrl];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selItem = [_dataArray objectAtIndex:indexPath.row];
}

@end
