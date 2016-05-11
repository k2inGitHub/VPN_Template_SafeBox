//
//  VPNUnlockController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/9.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNUnlockController.h"
#import "HLService.h"
#import "VPNManager.h"
#import "KTUIFactory.h"
#import "KTMathUtil.h"
#import "NSUserDefaults+KTAdditon.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+Blocks.h"

@interface VPNUnlockController ()

@property (nonatomic, assign) int vipCount;

@property (nonatomic, assign) int vipCurrentCount;

@property (nonatomic, assign) BOOL adShow;

@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, weak) IBOutlet UIImageView *numView;

@property (nonatomic, weak) IBOutlet UIImageView *bgView;

@end

@implementation VPNUnlockController

- (IBAction)onBtnClick:(id)sender{
    
    if ([[HLAdManager sharedInstance] isEncourageInterstitialLoaded]) {
        [[HLAdManager sharedInstance] showEncourageInterstitial];
    } else {
        [UIAlertView showWithTitle:nil message:@"广告还没有准备好  请稍后再试" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
    }
    
//    [self addVipCount];
}

- (void)onInterstitialPresent:(HLAdType *)adType{
    _adShow = NO;
}

- (void)onInterstitialFinish:(HLAdType *)adType {
    _adShow = YES;
    
}

- (void)updateCommitDetail{
    
    int idx = clamp(_vipCount - _vipCurrentCount, 1, 2);
    _numView.image = [UIImage imageNamed:[NSString stringWithFormat:@"vpn_num_%d", idx]];
}

- (void)addVipCount{
    
    
    _vipCurrentCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:_vipCurrentCount forKey:@"vpnCurrentCount"];
    [self updateCommitDetail];
    if (_vipCurrentCount >= _vipCount) {
        
        [[VPNManager sharedManager] setVPNEnable:YES];
        
        [self onCancel:nil];
        [KTUIFactory showAlertViewWithTitle:nil message:@"恭喜你，解锁成功！" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    } else {
        [KTUIFactory showAlertViewWithTitle:nil message:@"恭喜你已经成功激活了1个，继续加油哦~" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)onCancel:(id)sender{

    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)didBecomeActive:(NSNotification*)notification {
    NSDate *now = [NSDate date];
    NSDate *compere = [NSDate dateWithTimeInterval:30 sinceDate:_lastDate];
    if (_adShow && [now compare:compere] > 0) {
        [self addVipCount];
    } else {
        _adShow = NO;
    }
}

- (void)willResignActive:(NSNotification*)notification {
//    if (_adShow) {
        _lastDate = [NSDate date];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adShow = false;
    _lastDate = [NSDate distantFuture];
    _adShow = NO;
    _vipCurrentCount = [[NSUserDefaults standardUserDefaults]integerForKey:@"vpnCurrentCount" defaultValue:0];
    _vipCount = [[VPNManager sharedManager].alertDic[@"vpnCount"] intValue];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self updateCommitDetail];
    
    [_bgView sd_setImageWithURL:[NSURL URLWithString:[HLInterface sharedInstance].girl_img_url] placeholderImage:_bgView.image];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFinish:) name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialPresent:) name:HLInterstitialPresentNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    
    [VPNManager eventGoVPN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
