//
//  VPNManager.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNManager.h"
#import "VPNHomeModel.h"
#import "NSUserDefaults+KTAdditon.h"
#import "KTUIFactory.h"
#import "HLService.h"
#import "KTMathUtil.h"
#import "UIAlertView+Blocks.h"
#import "VPNAlertView.h"
#import "VPNPageController.h"

NSString * const VPNCurrencyDidChangeNotification = @"VPN_CurrencyDidChange";

NSString * const VPNVIPDidChangeNotification = @"VPN_VipDidChange";

NSString * const VPNStatusDidChangeNotification = @"VPNStatusDidChangeNotification";


@interface VPNManager () <UIAlertViewDelegate>

@end

@implementation VPNManager

+ (void)eventGoVPN{
    BOOL hasEvent = [[NSUserDefaults standardUserDefaults] boolForKey:@"eventGoVPN" defaultValue:NO];
    if (!hasEvent) {
        [HLAnalyst event:@"进入激活VPN弹窗人数"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"eventGoVPN"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)eventGoVIP{
    BOOL hasEvent = [[NSUserDefaults standardUserDefaults] boolForKey:@"eventGoVIP" defaultValue:NO];
    if (!hasEvent) {
        [HLAnalyst event:@"进入激活VIP弹窗人数"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"eventGoVIP"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)showLaunchAd{
    if ([HLAnalyst boolValue:@"showLaunchAd" defaultValue:NO]) {
        [[HLAdManager sharedInstance] showSplashInterstitial];
    }
}

+ (void)showAd1{
    if ([HLAnalyst floatValue:@"showAd1" defaultValue:0.5] > [KTMathUtil randomFloatRange:0 and:1]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}

+ (void)showAd2{
    if ([HLAnalyst floatValue:@"showAd2" defaultValue:0.5] > [KTMathUtil randomFloatRange:0 and:1]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}


- (void)setisVip:(BOOL)isVip{
    if (isVip != [self isVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:isVip forKey:@"VPN_isVip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:VPNVIPDidChangeNotification object:nil];
        
        if (isVip) {
            [self setStatus:VPNStatusDisconnected];
            [HLAnalyst event:@"成功激活VIP人数"];
        }
    }
}

- (BOOL)isVip
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_isVip" defaultValue:NO];
}

- (void)setVPNEnable:(BOOL)enable{

    if (enable != [self isVPNEnable]) {
        [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"VPN_VPNEnable"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (enable) {
            [self setStatus:VPNStatusDisconnected];
            [HLAnalyst event:@"成功激活VPN人数"];
        }
    }
}

- (BOOL)isVPNEnable{

    return [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_VPNEnable" defaultValue:NO];
}


+ (instancetype)sharedManager
{
    static VPNManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[VPNManager alloc] init];
    });
    return _sharedManager;
}

- (void)setCurrency:(NSUInteger)currency
{
    if (_currency != currency) {
        _currency = currency;
        [[NSUserDefaults standardUserDefaults] setInteger:_currency forKey:@"VPN_Currency"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:VPNCurrencyDidChangeNotification object:nil];
    }
}

- (void)setStatus:(VPNStatus)status{
    if (_status != status) {
        
        _status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:VPNStatusDidChangeNotification object:nil];
    }
}

- (BOOL)costCurrency:(NSUInteger)cost {
    
    if (cost > _currency) {
        
        if (_currency < 50) {
            [KTUIFactory showAlertViewWithTitle:nil message:@"您已经没有金币了，观看完整视频广告可获得500金币！" delegate:self tag:0 cancelButtonTitle:@"拒绝" otherButtonTitles:@"免费金币", nil];
        } else {
            
            [UIAlertView showWithTitle:nil message:@"金币不足,去赚钱！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                [self performSelector:@selector(setSelectIdx) withObject:nil afterDelay:0];
            }];
        }
        
        return NO;
    }
    self.currency -= cost;
    return YES;
}

- (void)setSelectIdx{
    [VPNAlertView hideAllAlertViews];
    _pageContrller.selectIndex = 2;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
#if TARGET_IPHONE_SIMULATOR
        [self onInterstitialFinish:nil];
#else
        [[HLAdManager sharedInstance] showEncourageInterstitial];
#endif
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFinish:) name:HLInterstitialFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFailure:) name:HLInterstitialFailureNotification object:nil];
    }
}

- (void)onInterstitialFailure:(HLAdType *)adType {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:HLInterstitialFailureNotification object:nil];
}

- (void)onInterstitialFinish:(HLAdType *)adType{
    self.currency += 500;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:HLInterstitialFailureNotification object:nil];

    [UIAlertView showWithTitle:nil message:@"获得金币" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
}

- (void)addCurrency:(NSUInteger)add {
    self.currency += add;
}

- (void)setHasFavor:(BOOL)hasFavor{
    
    _hasFavor = hasFavor;
    [[NSUserDefaults standardUserDefaults] setBool:_hasFavor forKey:@"vpn_hasFavor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.hasFavor = [[NSUserDefaults standardUserDefaults] boolForKey:@"vpn_hasFavor" defaultValue:NO];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"VPN" bundle:nil];
    
    NSString *rootString = [HLAnalyst stringValue:@"VPNConfigData"];
//    NSLog(@"rootString = %@", rootString);
    NSData *rootData = [rootString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary *root = rootData.length>0 ? [NSPropertyListSerialization propertyListWithData:rootData options:NSPropertyListImmutable format:&format error:&error] : nil;
    
//    NSLog(@"NSDictionary = %@", root);
    
    if (!root || [root count] == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"VPNConfigData"    ofType:@"plist"];
        root = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    NSDictionary* home = root[@"home"];
    NSArray* homeDataArray = home[@"dataArray"];
    
    _homeDataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in homeDataArray) {
        if (![dic[@"hidden"] boolValue]) {
            [_homeDataArray addObject:[[VPNHomeModel alloc] initWithDict:dic]];
        }
    }
    
    _serverDataArray = root[@"center"][@"serverDataArray"];
    
    self.descriptionText = root[@"alert"][@"descriptionText"];
    
    self.loadDescriptionText = root[@"alert"][@"loadDescriptionText"];
    
    _currency = [[NSUserDefaults standardUserDefaults] integerForKey:@"VPN_Currency" defaultValue:[root[@"baseCurrency"] intValue]];
    
#if VPN_Debug
    _currency = 10000;
#endif
    
    _currencyDic = root[@"currency"];
    
    _alertDic = root[@"alert"];
    
    if ([self isVPNEnable]) {
        _status = VPNStatusDisconnected;
    } else {
        _status = VPNStatusInvalid;
    }
    

    
    return self;
}

@end
