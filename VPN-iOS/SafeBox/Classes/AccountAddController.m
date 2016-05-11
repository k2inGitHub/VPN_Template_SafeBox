//
//  AccountAddController.m
//  SafeBox
//
//  Created by SongYang on 14-3-20.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "AccountAddController.h"
#import "SBManager.h"
#import <QuartzCore/QuartzCore.h>

@interface AccountAddController ()

@end

@implementation AccountAddController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)createView:(NSArray *)labels
{
    for (int i = 0; i < labels.count; i++) {
        
        NSString *name = [labels objectAtIndex:i];
        
        UILabel *label = [KTUIFactory customLabelWithFrame:CGRectMake(10, 5 + 50*i, 60, 40) text:name textColor:[UIColor blackColor] textFont:@"Arial" textSize:15 textAlignment:UITextAlignmentCenter];
        [_scrollView addSubview:label];
        
        
        NSString *placeholder = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Input", @"Input"), name];
        UIKeyboardType keyboardType = UIKeyboardTypeDefault;
        UIReturnKeyType returnKeyType = UIReturnKeyDone;
        CGRect frame = CGRectMake(80, 5 + 50*i, 230, 40);
        if ([name isEqualToString:NSLocalizedString(@"Notes", @"Notes")]) {
            frame.size = CGSizeMake(230, 100);
            placeholder = nil;
        }
        if ([name isEqualToString:NSLocalizedString(@"CardNum", @"CardNum")]) {
            keyboardType = UIKeyboardTypeNumberPad;
        }
        if ([name isEqualToString:NSLocalizedString(@"Phone", @"Phone")]) {
            keyboardType = UIKeyboardTypeNumberPad;
        }
        if ([name isEqualToString:NSLocalizedString(@"CVC Code", @"CVC Code")]) {
            keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if ([name isEqualToString:NSLocalizedString(@"Notes", @"Notes")]) {
            UITextView *tv = [[UITextView alloc] initWithFrame:frame];
            tv.tag = i+32;
            
            tv.keyboardType = keyboardType;
            [_scrollView addSubview:tv];
            tv.returnKeyType = returnKeyType;
            tv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
            tv.layer.borderWidth = 1.0;
            tv.layer.cornerRadius = 5.0;
            if (!_isAdd) {
                tv.text = [_curDict objectForKey:[self keyFromLabel:name]];
                [tv setEditable:NO];
            } else {
                [tv setEditable:YES];
            }
        } else {
            UITextField *tf = [[UITextField alloc] initWithFrame:frame];
            tf.tag = i+32;
            tf.borderStyle = UITextBorderStyleLine;
            tf.layer.borderWidth = 1.0;
            tf.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
            tf.layer.cornerRadius = 5.0;
            tf.placeholder = placeholder;
            tf.keyboardType = keyboardType;
            
            tf.returnKeyType = returnKeyType;
            [_scrollView addSubview:tf];
            if (!_isAdd) {
                tf.text = [_curDict objectForKey:[self keyFromLabel:name]];
                tf.enabled = NO;
            } else {
                tf.enabled = YES;
            }
        }
        
    }
}

- (NSString *)keyFromLabel:(NSString *)label
{
    NSString *key;
    if ([label isEqualToString:NSLocalizedString(@"Title", @"Title")]) {
        key = @"bt";
    } else if ([label isEqualToString:NSLocalizedString(@"CardNum", @"CardNum")]) {
        key = @"kh";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Password", @"Password")]) {
        key = @"mm";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Phone", @"Phone")]) {
        key = @"dh";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Website", @"Website")]) {
        key = @"wz";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Notes", @"Notes")]) {
        key = @"bz";
    }
    else if ([label isEqualToString:NSLocalizedString(@"CVC Code", @"CVC Code")]) {
        key = @"cvc";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Valid Date", @"Valid Date")]) {
        key = @"rq";
    }
    else if ([label isEqualToString:NSLocalizedString(@"Account", @"Account")]) {
        key = @"zh";
    }
    return key;
}

- (NSString *)labelFromKey:(NSString *)key
{
    NSString *label;
    if ([key isEqualToString:@"bt"]) {
        label = NSLocalizedString(@"Title", @"Title");
    } else if ([key isEqualToString:@"kh"]) {
        label = NSLocalizedString(@"CardNum", @"CardNum");
    }
    else if ([key isEqualToString:@"mm"]) {
        label = NSLocalizedString(@"Password", @"Password");
    }
    else if ([key isEqualToString:@"dh"]) {
        label = NSLocalizedString(@"Phone", @"Phone");
    }
    else if ([key isEqualToString:@"wz"]) {
        label = NSLocalizedString(@"Website", @"Website");
    }
    else if ([key isEqualToString:@"bz"]) {
        label = NSLocalizedString(@"Notes", @"Notes");
    }
    else if ([key isEqualToString:@"cvc"]) {
        label = NSLocalizedString(@"CVC Code", @"CVC Code");
    }
    else if ([key isEqualToString:@"rq"]) {
        label = NSLocalizedString(@"Valid Date", @"Valid Date");
    }
    else if ([key isEqualToString:@"zh"]) {
        label = NSLocalizedString(@"Account", @"Account");
    }
    return label;
}

- (void)bbiAction:(UIBarButtonItem *)item
{
    if (_isAdd) {
        //完成
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < _labels.count; i++) {
            id view = [_scrollView viewWithTag:i+32];
            NSString *v = ([view valueForKey:@"text"] == nil) ? @"" : [view valueForKey:@"text"];
            [dict setObject:v forKey:[self keyFromLabel:[_labels objectAtIndex:i]]];
        }
        
        NSLog(@"self.type = %@", _type);
        
        NSLog(@"");
        
        
        NSDictionary * accountDict = [SBManager sharedManaegr].accountDict;
        NSMutableArray *records = [[accountDict objectForKey:self.type] objectForKey:@"records"];
        
        [records addObject:dict];
        
    
        [[SBManager sharedManaegr] flushAccount];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //编辑模式
        
        _isEdit = !_isEdit;
        
        if (_isEdit) {
            self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"Done");
            for (int i = 0; i < _labels.count; i++) {
                
                id view = [_scrollView viewWithTag:i + 32];
                
                if ([view isKindOfClass:[UITextView class]]) {
                    ((UITextView *)view).editable = YES;
                } else {
                    ((UITextField *)view).enabled = YES;
                }
            }
        } else {
            //完成编辑
            for (int i = 0; i < _labels.count; i++) {
                id view = [_scrollView viewWithTag:i+32];
                [_curDict setObject:[view valueForKey:@"text"] forKey:[self keyFromLabel:[_labels objectAtIndex:i]]];
            }
            [[SBManager sharedManaegr] flushAccount];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Add new record", @"Add new record");
    
    _isEdit = NO;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:_isAdd?NSLocalizedString(@"Done", @"Done"):NSLocalizedString(@"Edit", @"Edit") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    right.tag = 10;
    self.navigationItem.rightBarButtonItem = right;
    
    
    if ([self.type isEqualToString:@"cx"]) {
        self.labels = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Title", @"Title"), NSLocalizedString(@"CardNum", @"CardNum"), NSLocalizedString(@"Password", @"Password"), NSLocalizedString(@"Phone", @"Phone"), NSLocalizedString(@"Website", @"Website"), NSLocalizedString(@"Notes", @"Notes"), nil];
    } else if ([self.type isEqualToString:@"xy"]) {
        self.labels = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Title", @"Title"), NSLocalizedString(@"CardNum", @"CardNum"), NSLocalizedString(@"CVC Code", @"CVC Code"), NSLocalizedString(@"Valid Date", @"Valid Date"), NSLocalizedString(@"Phone", @"Phone"), NSLocalizedString(@"Website", @"Website"), NSLocalizedString(@"Notes", @"Notes"), nil];
    } else if ([self.type isEqualToString:@"yx"]) {
        self.labels = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Title", @"Title"), NSLocalizedString(@"Website", @"Website"), NSLocalizedString(@"Account", @"Account"), NSLocalizedString(@"Password", @"Password"), NSLocalizedString(@"Notes", @"Notes"), nil];
    } else {
        self.labels = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Title", @"Title"), NSLocalizedString(@"Website", @"Website"), NSLocalizedString(@"Account", @"Account"), NSLocalizedString(@"Notes", @"Notes"), nil];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 20);
    
    
    _keyboardIsShown = NO;
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:self.view.window];
                                                                // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];

    [self createView:self.labels];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    if (_keyboardIsShown) {
        return;
    }
    NSDictionary *userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= (keyboardSize.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    _keyboardIsShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame.size.height += (keyboardSize.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    _keyboardIsShown = NO;
}


@end
