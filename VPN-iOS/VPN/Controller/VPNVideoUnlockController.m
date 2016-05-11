//
//  VPNVideoUnlockController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNVideoUnlockController.h"
#import "AFNetworking.h"
#import "HLService.h"
#import "VPNManager.h"
#import "MBProgressHUD.h"

@interface VPNVideoUnlockController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic, assign) BOOL keepRatioEnabled;

@end

@implementation VPNVideoUnlockController

- (void)setURL:(int)videoSource :(NSString *)videoUrl
{
    if (self.moviePlayer != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
        
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
    }
    
    if (videoSource == 1) {
        self.moviePlayer = [[MPMoviePlayerController alloc] init];
        self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [self.moviePlayer setContentURL:[NSURL URLWithString:videoUrl]];
    } else {
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoUrl]];
        self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    }
    self.moviePlayer.allowsAirPlay = false;
    self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayer.view.userInteractionEnabled = true;
    
    UIColor *clearColor = [UIColor clearColor];
    self.moviePlayer.backgroundView.backgroundColor = clearColor;
    self.moviePlayer.view.backgroundColor = clearColor;
    for (UIView * subView in self.moviePlayer.view.subviews) {
        subView.backgroundColor = clearColor;
    }
    
    if (_keepRatioEnabled) {
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    } else {
        self.moviePlayer.scalingMode = MPMovieScalingModeFill;
    }
    
    [self.view addSubview:self.moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
}

-(void) videoFinished:(NSNotification *)notification
{
    UIViewController *vc = [[VPNManager sharedManager].storyboard instantiateViewControllerWithIdentifier:@"unlock"];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void) playStateChange
{
    MPMoviePlaybackState state = [self.moviePlayer playbackState];
    switch (state) {
        case MPMoviePlaybackStatePaused:
//            _videoPlayer->onPlayEvent((int)VideoPlayer::EventType::PAUSED);
            break;
        case MPMoviePlaybackStateStopped:
//            _videoPlayer->onPlayEvent((int)VideoPlayer::EventType::STOPPED);
            break;
        case MPMoviePlaybackStatePlaying:
//            _videoPlayer->onPlayEvent((int)VideoPlayer::EventType::PLAYING);
            break;
        case MPMoviePlaybackStateInterrupted:
            break;
        case MPMoviePlaybackStateSeekingBackward:
            break;
        case MPMoviePlaybackStateSeekingForward:
            break;
        default:
            break;
    }
}

-(void) play
{
    if (self.moviePlayer != NULL) {
        [self.moviePlayer.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        [self.moviePlayer play];
    }
}

-(void) pause
{
    if (self.moviePlayer != NULL) {
        [self.moviePlayer pause];
    }
}

-(void) resume
{
    if (self.moviePlayer != NULL) {
        if([self.moviePlayer playbackState] == MPMoviePlaybackStatePaused)
        {
            [self.moviePlayer play];
        }
    }
}

-(void) stop
{
    if (self.moviePlayer != NULL) {
        [self.moviePlayer stop];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.keepRatioEnabled = YES;

    
    if ([HLInterface sharedInstance].ctrl_unlock_default_video_switch == 1) {
        [self setURL:0 :[self girlDefaultPath]];
        [self play];
    } else {
        if ([self isGirlOnlineExists]) {
            [self setURL:0 :[self girlOnlinePath]];
            [self play];
        } else {
            [self requestData];
        }
    }
}

- (BOOL)isGirlOnlineExists{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self girlOnlinePath]];
}

- (NSString *)vpnDiretory{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    [path stringByAppendingPathComponent:@"VPN"];
    return path;
}

- (NSString *)girlDefaultPath{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"night_girl_004.mp4"];
}

- (NSString *)girlOnlinePath{
    
    NSString *filename = [[HLInterface sharedInstance].girl_video_url lastPathComponent];
    return [[self vpnDiretory] stringByAppendingPathComponent:filename];
}

- (void)requestData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/x-m4v", @"video/mp4", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    [manager GET:[HLInterface sharedInstance].girl_video_url parameters:nil progress:^(NSProgress *progress){hud.progress = progress.fractionCompleted;} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[self vpnDiretory] withIntermediateDirectories:YES attributes:nil error:nil];
        
        
        if ([[NSFileManager defaultManager]createFileAtPath:[self girlOnlinePath] contents:responseObject attributes:nil]) {
            [self setURL:0 :[self girlOnlinePath]];
            [self play];
        }
        [hud hide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [hud hide:YES];
        [self setURL:0 :[self girlDefaultPath]];
        [self play];
    }];
}

-(void) dealloc
{
    if (self.moviePlayer != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
        
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
    }
}

@end
