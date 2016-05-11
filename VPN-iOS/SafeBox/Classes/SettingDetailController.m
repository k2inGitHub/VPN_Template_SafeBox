//
//  SettingDetailController.m
//  SafeBox
//
//  Created by SongYang on 14-3-24.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SettingDetailController.h"
#import "KKKeychain.h"

@interface SettingDetailController ()

@end

@implementation SettingDetailController

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
    NSMutableArray *strs = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < _texts.count; i++) {
        UITextField *tf = [_texts objectAtIndex:i];
        [strs addObject:tf.text];
        if ([tf.text isEqualToString:@""]) {
            if (i == 0) {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"Old password is empty，please input", @"Old password is empty，please input") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            } else if (i == 1) {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"New password is empty，please input", @"New password is empty，please input") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            } else {
                [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"Repeat password is empty,please input", @"Repeat password is empty,please input") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
            }
            return;
        }
    }
    
    if (![[strs objectAtIndex:1] isEqualToString:[strs objectAtIndex:2]]) {
        [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"Two passwords are diferent, please re-enter", @"Two passwords are diferent, please re-enter") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
        return;
    }
    if ([[strs objectAtIndex:0] length]!=4 || [[strs objectAtIndex:1] length]!=4 || [[strs objectAtIndex:2] length]!=4) {
        [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"Password must be four characters", @"Password must be four characters") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
        return;
    }
    NSString *passcode = [KKKeychain getStringForKey:@"passcode"];

    if (![passcode isEqualToString:[strs objectAtIndex:0]]) {
        [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify failed", @"Modify failed") message:NSLocalizedString(@"The old password is incorrect,please re-enter!!!", @"The old password is incorrect,please re-enter!!!") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
        return;
    }
    if ([KKKeychain setString:[strs objectAtIndex:1] forKey:@"passcode"]) {
        [KKKeychain setString:@"YES" forKey:@"passcode_on"];
        [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Modify password success", @"Modify password success") message:nil delegate:self tag:20 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 4) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = _name;
    
    
    
    if ([_name isEqualToString:NSLocalizedString(@"Modify Login Password", @"Modify Login Password")]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Modify", @"Modify") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
        _texts = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *titles = @[NSLocalizedString(@"Please enter old password", @"Please enter old password"), NSLocalizedString(@"Enter new password", @"Enter new password"), NSLocalizedString(@"Enter new password again", @"Enter new password again")];
        
        for (int i = 0; i < titles.count; i++) {
            UITextField *tf0 = [[UITextField alloc] initWithFrame:CGRectMake(20, 30 + i*40, 280, 30)];
            tf0.borderStyle = UITextBorderStyleRoundedRect;
            tf0.delegate = self;
            tf0.keyboardType = UIKeyboardTypeNumberPad;
            tf0.tag = i;
            tf0.secureTextEntry = YES;
            tf0.placeholder = [titles objectAtIndex:i];
            [self.view addSubview:tf0];
            [_texts addObject:tf0];
        }
        
    } else if ([_name isEqualToString:NSLocalizedString(@"About Info", @"About Info")]){
        
        UILabel *about = [KTUIFactory customLabelWithFrame:CGRectMake(0, 0, 180, 24) text:NSLocalizedString(@"SafeBox", @"SafeBox") textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:20 textAlignment:UITextAlignmentCenter];
        about.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:about];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-72.png"]];
        icon.center = CGPointMake(self.view.frame.size.width/2, about.center.y - 80);
        [self.view addSubview:icon];
    }
    
}


@end
