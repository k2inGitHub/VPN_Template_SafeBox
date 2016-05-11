//
//  VPNCurrencyController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNCurrencyController.h"
#import "UIButton+WebCache.h"
#import "HLService.h"

@interface VPNCurrencyController ()

@property (nonatomic, weak) IBOutlet UIView *spinContainerView;

@property (nonatomic, weak) IBOutlet UIView *guessContainerView;

@property (nonatomic, weak) IBOutlet UIButton *spinBtn;

@property (nonatomic, weak) IBOutlet UIButton *guessBtn;

@property (nonatomic, weak) IBOutlet UIButton *button_2;

@end

@implementation VPNCurrencyController

- (IBAction)pageSelect:(UIButton *)sender{
    if (_spinBtn == sender) {
        _spinContainerView.hidden = NO;
        _spinBtn.selected = YES;
        _guessContainerView.hidden = YES;
        _guessBtn.selected = NO;
        
    } else {
        _spinContainerView.hidden = YES;
        _spinBtn.selected = NO;
        _guessContainerView.hidden = NO;
        _guessBtn.selected = YES;
    }
    
}

- (IBAction)onBtn2:(id)sender{
    [HLAnalyst event:@"点击小广告图次数"];
    [[HLAdManager sharedInstance] showButtonInterstitial:@"赚金币"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageSelect:_spinBtn];
    [_button_2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[HLInterface sharedInstance].ctrl_btn_img_url_02] forState:UIControlStateNormal placeholderImage:[_button_2 backgroundImageForState:UIControlStateNormal]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
