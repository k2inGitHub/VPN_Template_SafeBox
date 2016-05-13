//
//  VPNFavorController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/5/11.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNFavorController.h"
#import "ZLSwipeableView.h"
#import "Masonry.h"
#import "HLService.h"
#import "UIAlertView+blocks.h"
#import "NSUserDefaults+KTAdditon.h"
#import "VPNManager.h"

@interface VPNFavorController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, assign) int swipeIdx;

@property (nonatomic, assign) int leftNum;

@property (nonatomic, assign) int rightNum;

@property (nonatomic, assign) int swipeNum;

@property (nonatomic, assign) int stepIdx;

@property (nonatomic, assign) int step1MaxNum;

@property (nonatomic, assign) int step2MaxNum;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *leftCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *rightCountLabel;

@property (nonatomic, weak) IBOutlet UIView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *finishView;

@property (nonatomic, weak) IBOutlet UIButton *step1Btn;

@property (nonatomic, weak) IBOutlet UIButton *step2Btn1;

@property (nonatomic, weak) IBOutlet UIButton *step2Btn2;

@property (nonatomic, weak) IBOutlet UILabel *topTitleLabel;


@end

@implementation VPNFavorController

- (IBAction)onStart:(id)sender {

    [VPNManager sharedManager].hasFavor = YES;
    
    UIViewController *pageController = [[UIStoryboard storyboardWithName:@"VPN" bundle:nil] instantiateViewControllerWithIdentifier:@"page"];
    
    [self.navigationController setViewControllers:@[pageController] animated:NO];
}

- (IBAction)onReselect:(id)sender {
    self.stepIdx = 0;
    self.finishView.hidden = YES;
    [self.dataArray removeAllObjects];
    for (int i = 0; i < 25; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"bg_flip_girl_%d", i+1]];
    }
    _swipeIdx = _swipeNum = _leftNum = _rightNum = 0;
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
    [self updateStep];
    [self updateNumLabel];
}

- (IBAction)onNext:(id)sender{

    self.stepIdx++;
    self.finishView.hidden = YES;
    [self.dataArray removeAllObjects];
    for (int i = 0; i < 10; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"bg_flip_scene_%d", i+1]];
    }
    _swipeIdx = _swipeNum = _leftNum = _rightNum = 0;
    
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
    [self updateStep];
    [self updateNumLabel];
}

- (void)updateStep{
    
    if (self.stepIdx == 0) {
        self.step1Btn.hidden = NO;
        self.step2Btn2.hidden = self.step2Btn1.hidden = YES;
        _topTitleLabel.text = @"选择你喜欢的女演员";
    } else {
        self.step1Btn.hidden = YES;
        self.step2Btn2.hidden = self.step2Btn1.hidden = NO;
        _topTitleLabel.text = @"选择你喜欢的场景";
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"选择喜好(%d/%d)", _stepIdx+1, 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.step1MaxNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"vip_favor_step1Max" defaultValue:10];
    self.step2MaxNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"vip_favor_step2Max" defaultValue:5];
    _swipeIdx = _swipeNum = _stepIdx = _leftNum = _rightNum = 0;
    [self updateNumLabel];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:223.f/255.f green:36.f/255.f blue:119.f/255.f alpha:1];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 36)];
    _titleLabel.text = @"选择喜好";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = _titleLabel;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfHistoryItem = NSUIntegerMax;
    [self performSelector:@selector(delaySetup) withObject:nil afterDelay:0];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i = 0; i < 25; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"bg_flip_girl_%d", i+1]];
    }
    
    self.finishView.hidden = YES;
    
    
    [self updateStep];
    
    
    

}

- (void)delaySetup
{
    
    _swipeIdx = _swipeNum = _stepIdx = _leftNum = _rightNum = 0;
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

- (void)updateViewConstraints{
    [_leftCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.bottom.offset(-90);
        } else {
            make.bottom.offset(-50);
        }
    }];
    
    [_rightCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.bottom.offset(-90);
        } else {
            make.bottom.offset(-50);
        }
    }];
    [super updateViewConstraints];
}

- (int)maxNum{
    if (_stepIdx == 0) {
        return _step1MaxNum;
    }
    return _step2MaxNum;
}

- (void)onInterstitialFinish:(HLAdType *)adType{

    if (_stepIdx == 0) {
        _step1MaxNum++;
        [[NSUserDefaults standardUserDefaults] setInteger:_step1MaxNum forKey:@"vip_favor_step1Max"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        _step2MaxNum++;
        [[NSUserDefaults standardUserDefaults] setInteger:_step2MaxNum forKey:@"vip_favor_step2Max"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [UIAlertView showWithTitle:nil message:@"爱看上限+1" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:HLInterstitialFailureNotification object:nil];
}

- (void)onInterstitialFailure:(HLAdType *)adType{

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:HLInterstitialFailureNotification object:nil];
}

#pragma mark - swipe

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction{

    NSLog(@"spwipe");
    BOOL flag = YES;
    if (direction == ZLSwipeableViewDirectionLeft) {
        _leftNum++;
    } else if (direction == ZLSwipeableViewDirectionRight) {
        
        if (_rightNum >= [self maxNum]) {
            [UIAlertView showWithTitle:nil message:@"已满上限 少侠注意身体（点击【我身体好】，看完动画后可以上限+1）" cancelButtonTitle:nil otherButtonTitles:@[@"身体重要", @"我身体好"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                NSLog(@"buttonIndex = %ld", buttonIndex);
                
                if (buttonIndex == 1) {
#if TARGET_IPHONE_SIMULATOR
                    [self onInterstitialFinish:nil];
#else
                    [[HLAdManager sharedInstance] showEncourageInterstitial];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFinish:) name:HLInterstitialFinishNotification object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFailure:) name:HLInterstitialFailureNotification object:nil];
#endif
                }
            }];
            
            [self.swipeableView rewind];
            flag = NO;
        } else {
        
            _rightNum++;
        }
    }
    [self updateNumLabel];
    
    if (flag) {
        _swipeNum++;
        [VPNManager showAd1];
    }
    if (_swipeNum >= self.dataArray.count) {
        
        self.finishView.hidden = NO;
        
    }
}

- (void)updateNumLabel{
    _leftCountLabel.text = [NSString stringWithFormat:@"%d个不看", _leftNum];
    _rightCountLabel.text = [NSString stringWithFormat:@"%d个爱看", _rightNum];
}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    if (self.swipeIdx >= self.dataArray.count) {
        return nil;
    }
    UIImageView *view = [[UIImageView alloc] initWithFrame:swipeableView.bounds];
    view.image = [UIImage imageNamed:self.dataArray[self.swipeIdx]];
    UIImageView *bottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_flip_world"]];
    float height = view.frame.size.width * 143.f / 553.f;
    bottom.frame = CGRectMake(0, 0, view.frame.size.width, height);
    [view addSubview:bottom];
    bottom.center = CGPointMake(view.frame.size.width/2, view.frame.size.height - height * 0.5);
    
    self.swipeIdx++;
    
    return view;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLInterstitialFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:HLInterstitialFailureNotification object:nil];
}

@end
