//
//  AccountPreviewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "AccountPreviewController.h"
#import "AccountAddController.h"

@interface AccountPreviewController ()

@end

@implementation AccountPreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateTooBar
{
    UIBarButtonItem *item ;
    for (UIBarButtonItem *it in [self.toolBar items]) {
        if (it.tag == 100) {
            item = it;
            break;
        }
    }
    
    if ([[_accountDict objectForKey:@"pw"]isEqualToString:@""]) {
        //没有密码
        item.image = [UIImage imageNamed:@"toolbar_unlock"];
    } else {
        item.image = [UIImage imageNamed:@"toolbar_lock"];
    }
}
- (void)createToolBar
{
    //toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.winSize.height - 44 - 44, self.winSize.width, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.translucent = NO;
    toolBar.tintColor = self.navigationController.navigationBar.tintColor;
    toolBar.backgroundColor = self.navigationController.navigationBar.tintColor;
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;//这句作用是切换时宽度自适应.
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSArray *imgs = [NSArray arrayWithObjects:@"",@"",@"",@"toolbar_lock",@"",@"",@"",@"toolbar_new",@"",@"",@"", nil];
    int tag = 100;
    for (NSString *img in imgs) {
        UIBarButtonItem *item;
        if ([img isEqualToString:@""]) {
            item = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:self
                                 action:NULL];
            
        } else {
            item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
            item.tag = tag;
            tag+=10;
        }
        [items addObject:item];
    }
    
    [toolBar setItems:items];
    [self updateTooBar];
    
    CGRect rect = toolBar.frame;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        rect.origin.y = rect.origin.y-90;
    } else {
        rect.origin.y = rect.origin.y-50;
    }
    
    toolBar.frame = rect;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            //设置密码
            NSString *text0 = [alertView textFieldAtIndex:0].text;
            NSString *text1 = [alertView textFieldAtIndex:1].text;
            if (!text0 || !text1 || [text0 isEqualToString:@""] || [text1 isEqualToString:@""]) {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Password can't be empty", @"Password can't be empty") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            } else if (![text0 isEqualToString:text1]) {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Two passwords different", @"Two passwords different") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            } else {
                [_accountDict setObject:text0 forKey:@"pw"];
                [[SBManager sharedManaegr] flushAccount];
                [self updateTooBar];
            }
        }
    } else if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            NSString *text = [alertView textFieldAtIndex:0].text;
            if ([[_accountDict objectForKey:@"pw"] isEqualToString:text]) {
                //取消
                [_accountDict setObject:@"" forKey:@"pw"];
                [[SBManager sharedManaegr] flushAccount];
                [self updateTooBar];
            } else if (!text || [text isEqualToString:@""]){
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Password can't be empty", @"Password can't be empty") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
            } else {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Remove password failed", @"Remove password failed") message:NSLocalizedString(@"Old password incorrect", @"Old password incorrect") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
            }
        }
    }
}

- (void)bbiAction:(UIBarButtonItem *)item
{
    if (item.tag == 100) {
        //lock
        
        if ([[_accountDict objectForKey:@"pw"] isEqualToString:@""]) {
            //设置密码
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Set password", @"Set password") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
            view.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            UITextField *tf0 = [view textFieldAtIndex:0];
            UITextField *tf1 = [view textFieldAtIndex:1];
            tf0.placeholder = NSLocalizedString(@"Password", @"Password");
            tf0.secureTextEntry = YES;
            tf1.placeholder = NSLocalizedString(@"Repeat password", @"Repeat password");
            tf1.secureTextEntry = YES;
            view.tag = 0;
            [view show];
        } else {
            //取消密码
            [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Remove password", @"Remove password") delegate:self tag:10 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
        }
    } else {
        //edit
        AccountAddController *vc = [[AccountAddController alloc] init];
        vc.type = self.type;
        vc.isAdd = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Savings Card", @"Savings Card")]) {
        self.type = @"cx";
    } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Credit Card", @"Credit Card")]) {
        self.type = @"xy";
    } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Mail", @"Mail")]) {
        self.type = @"yx";
    } else {
        self.type = @"wz";
    }

    self.accountDict = [[SBManager sharedManaegr].accountDict objectForKey:self.type];
    self.dataArray = [self.accountDict objectForKey:@"records"];
    
    NSLog(@"dataArray = %@", _dataArray);
    
    //tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.winSize.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self createToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
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
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bt"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:([_type isEqualToString:@"cx"] || [_type isEqualToString:@"xy"]) ? @"kh" : @"wz"]];
    
    float width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320;
    
    UILabel *label = [KTUIFactory customLabelWithFrame:CGRectMake(5, 42, width, 2) text:[KTUIFactory stringForTableViewDotLine] textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:6 textAlignment:UITextAlignmentLeft];
    [cell addSubview:label];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    AccountAddController *vc = [[AccountAddController alloc] init];
    vc.curDict = dict;
    vc.isAdd = NO;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
