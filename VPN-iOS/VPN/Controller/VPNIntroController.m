//
//  VPNIntroController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/9.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNIntroController.h"
#import "SDWebImageManager.h"
#import "HLService.h"
#import "VPNManager.h"

@interface VPNIntroController ()

@end

@implementation VPNIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
   [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: [HLInterface sharedInstance].girl_img_url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       
   }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnClick{
    UIViewController *vc = [[VPNManager sharedManager].storyboard instantiateViewControllerWithIdentifier:[HLInterface sharedInstance].ctrl_unlock_video_switch == 1 ? @"videoUnlock" : @"unlock"];
    [self.navigationController pushViewController:vc animated:NO];
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
