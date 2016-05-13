//
//  VPNCenterVieController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/22.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNCenterVieController.h"
#import "ActionSheetPicker.h"
#import "NSUserDefaults+KTAdditon.h"
#import "VPNManager.h"
#import "VPNAlertView.h"
#import "HLInterface.h"
#import "Masonry.h"
#import "Canvas.h"
#import "KTUIFactory.h"
#import "UIAlertView+Blocks.h"
#import "UIButton+WebCache.h"
#import "HLService.h"
//@import NetworkExtension;

//VPN
/*************************************************/
//#error 确认输入对应的字段值
#define kVPNName @"iaRS2s"
#define kServerAddress @"us09.dearip.me"
#define kLocalIdentifier @"vpn"
#define kRemoteIdentifier @"vpn"
/*************************************************/



//Keychain
#define kKeychainServiceName @"com.nakedtree.vpntest"//可以改成你需要的
//从Keychain取密码对应的key
#define kPasswordReference @"qg7vTdbsqP"
#define kSharedSecretReference @"netjsq"
#define kUserPassword  @"com.nakedtree.vpntes.kUserPassowrd"
#define kSharedSecret  @"com.nakedtree.vpntes.kSharedSecret"

@interface VPNCenterVieController ()

@property (nonatomic, weak) IBOutlet UILabel *serverNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *vpnLabel;

@property (nonatomic, weak) IBOutlet UISwitch *vpnSwitch;

@property (nonatomic, weak) IBOutlet UIButton *vipButton;

@property (nonatomic, strong) CADisplayLink* display;

@property (nonatomic, assign) BOOL forward;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel2;

@property (nonatomic, strong) NSArray* serverArray;

@property (nonatomic, strong) NSArray* titleArray;

//@property (nonatomic, assign) int serverIdx;

@property (nonatomic, weak) IBOutlet UIButton *button1;

@end

@implementation VPNCenterVieController

- (IBAction)showVIP:(id)sender{

    [VPNAlertView showWithAlertType:VPNAlertVIP];
}

- (IBAction)onBtn1:(id)sender{
    [HLAnalyst event:@"点击大广告图次数"];
    [[HLAdManager sharedInstance] showButtonInterstitial:@"VPN"];
}

- (void)setServerIdx:(int)serverIdx{
    [[NSUserDefaults standardUserDefaults] setInteger:serverIdx forKey:@"VPN_serverIdx"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)serverIdx{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"VPN_serverIdx" defaultValue:0];
}

- (NSData *)storeStringAndGet:(NSString *)string key:(NSString *)key {
    [self storeString:string key:key];
    return [self getDataWithKey:key];
}

- (OSStatus) storeString:(NSString *)string key:(NSString *)key
{
    NSDictionary *keychainQuery = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrGeneric : key,
                                    (__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecAttrService : kKeychainServiceName,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,
                                    (__bridge id)kSecValueData : [string dataUsingEncoding:NSUTF8StringEncoding]
                                    };
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, nil);
    if (status != errSecSuccess) {
        //        print("Unable add item with key = \(key) error: \(status)")
    }
    return status;
}

- (NSData *) getDataWithKey:(NSString *)key
{
    NSDictionary *keychainQuery = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrGeneric : key,
                                    (__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecAttrService : kKeychainServiceName,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,
                                    (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                                    (__bridge id)kSecReturnPersistentRef : @YES
                                    };
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, &result);
    if (status != errSecSuccess) {
        //        print("Unable add item with key = \(key) error: \(status)")
        
    }
    return (__bridge_transfer NSData *)result;
}

- (void)setupIPSec
{
//    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
//    p.username = kVPNName;
//    p.passwordReference = [self storeStringAndGet:kPasswordReference key:kUserPassword];//[self searchKeychainCopyMatching:kPasswordReference];
//    p.serverAddress = [self currentServerDic][@"ip"];
//    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
//    p.sharedSecretReference = [self storeStringAndGet:kSharedSecretReference key:kSharedSecret];
//    p.disconnectOnSleep = NO;
//    
//    //    NSLog(@"pw = %@", [self searchKeychainCopyMatching:kPasswordReference]);
//    //    NSLog(@"sharedSecretReference = %@", [self searchKeychainCopyMatching:kSharedSecretReference]);
//    //需要扩展鉴定(群组)
//    p.localIdentifier = kLocalIdentifier;
//    p.remoteIdentifier = kRemoteIdentifier;
//    p.useExtendedAuthentication = YES;
//    
//    [[NEVPNManager sharedManager] setProtocol:p];
//    [[NEVPNManager sharedManager] setOnDemandEnabled:NO];
//    [[NEVPNManager sharedManager] setLocalizedDescription:@"个人-VPN测试"];//VPN自定义名字
//    [[NEVPNManager sharedManager] setEnabled:YES];
}

- (NSDictionary *)currentServerDic{
    return _serverArray[[self serverIdx]];
}

- (void)updateViewConstraints{
    
    [_vipButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.bottom.offset(-90);
        } else {
            make.bottom.offset(-50);
        }
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _serverArray = [VPNManager sharedManager].serverDataArray;
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_serverArray.count];
    for (int i = 0; i < _serverArray.count; i++) {
        [titles addObject:_serverArray[i][@"server"]];
    }
    
    _titleArray = titles;
    
    _serverNameLabel.text = _titleArray[[self serverIdx]];
   
    [self VPNStatusDidChangeNotification];
    [self saveVPNPre];
    [self updateVIP];
    
    _descriptionLabel2.hidden = _descriptionLabel.hidden = ([HLInterface sharedInstance].market_reviwed_status == 0);
    
    _descriptionLabel2.text = [VPNManager sharedManager].descriptionText;
    
    [_button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[HLInterface sharedInstance].ctrl_btn_img_url_01] forState:UIControlStateNormal placeholderImage:[_button1 backgroundImageForState:UIControlStateNormal]];
    
    [self addDisplayLink];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVIP) name:VPNVIPDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:VPNStatusDidChangeNotification object:nil];
}


- (void)addDisplayLink
{
    [self.display invalidate];
    self.display = nil;
    if (self.display == nil) {
        CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTransform)];
        self.display = display;
        [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)changeTransform {

    _vipButton.transform = _forward ? CGAffineTransformScale(_vipButton.transform, 1.01,1.01) : CGAffineTransformScale(_vipButton.transform, 0.99,0.99);
    CGAffineTransform t = _vipButton.transform;
    float scale = sqrtf(t.a * t.a + t.c * t.c);
    if (scale >= 1.2) {
        _forward = NO;
        _vipButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } else if (scale <= 1) {
        _forward = YES;
        _vipButton.transform = CGAffineTransformMakeScale(1, 1);
    }
}


- (void)updateVIP {
    _vipButton.hidden = YES;//[[VPNManager sharedManager] isVip] || ([HLInterface sharedInstance].market_reviwed_status == 0);
}

- (void)saveVPNPre {
//    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
//        if(error)
//        {
//            NSLog(@"Load error: %@", error);
//        }
//        else
//        {
//            //配置IPSec
//            [self setupIPSec];
//            
//            //保存VPN到系统->通用->VPN->个人VPN
//            [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error){
//                if(error)
//                {
////                    ALERT(@"saveToPreferences", error.description);
//                    NSLog(@"Save error: %@", error);
//                }
//                else
//                {
//                    NSLog(@"Saved!");
////                    ALERT(@"Saved", @"Saved");
//                }
//            }];
//        }
//    }];
}

- (void)removeVPNPre {

//    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
//        if (!error)
//        {
//            [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
//                if(error)
//                {
//                    NSLog(@"Remove error: %@", error);
////                    ALERT(@"removeFromPreferences", error.description);
//                }
//                else
//                {
//                    NSLog(@"Remove!");
////                    ALERT(@"removeFromPreferences", @"删除成功");
//                }
//            }];
//        }
//    }];
}

- (void)connectVPN {
    if ([VPNManager sharedManager].isVPNEnable) {
        [VPNManager sharedManager].status = VPNStatusConnected;
    } else {
        [VPNManager sharedManager].status = VPNStatusInvalid;
        [VPNAlertView showWithAlertType:VPNAlertVPN];
    }
//    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
//        if (!error)
//        {
//            NSLog(@"connectVPN");
//            //配置IPSec
//            [self setupIPSec];
//            NSError *error;
//            [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&error];
//            NSLog(@"conn error = %@", error);
//        }
//    }];
}

- (void)disconnectVPN {
    if ([VPNManager sharedManager].isVPNEnable) {
        [VPNManager sharedManager].status = VPNStatusDisconnected;
    } else {
        [VPNManager sharedManager].status = VPNStatusInvalid;
    }
    
    
//    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
//        if (!error)
//        {
//            NSLog(@"disconnectVPN");
//            [[NEVPNManager sharedManager].connection stopVPNTunnel];
//        }
//    }];
}

- (IBAction)switchChange:(id)sender {
    [VPNManager showAd1];
    UISwitch* sw = (UISwitch *)sender;
    if (sw.on) {
        
        [self connectVPN];
    } else {
        [self disconnectVPN];
    }
    [self VPNStatusDidChangeNotification];
}

- (IBAction)showPicker:(id)sender{
    
    if ([_vpnLabel.text isEqualToString:@"已连接"]) {
        [UIAlertView showWithTitle:nil message:@"请先关闭VPN状态" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择服务器"
                                            rows:_titleArray
                                initialSelection:[self serverIdx]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
//                                                 picker, (long)selectedIndex, selectedValue);
                                           [self setServerIdx:(int)selectedIndex ];
                                           _serverNameLabel.text = selectedValue;
                                           [self saveVPNPre];
                                           [VPNManager showAd1];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
    
    
    switch ([VPNManager sharedManager].status)
    {
        case VPNStatusInvalid:
        {
            NSLog(@"NEVPNStatusInvalid");
            _vpnLabel.text = @"未配置";
            _vpnSwitch.on = NO;
            break;
        }
        case VPNStatusDisconnected:
        {
              _vpnLabel.text = @"未连接";
            _vpnSwitch.on = NO;
            NSLog(@"NEVPNStatusDisconnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        
        case VPNStatusConnected:
        {
            _vpnLabel.text = @"已连接";
            _vpnSwitch.on = YES;
            NSLog(@"NEVPNStatusConnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }

        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
