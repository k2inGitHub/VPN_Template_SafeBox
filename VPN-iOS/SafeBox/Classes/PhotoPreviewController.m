//
//  PhotoPreviewController.m
//  SafeBox
//
//  Created by SongYang on 14-3-19.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "PhotoPreviewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoDetailController.h"
#import "PhotoMoveController.h"

@interface PhotoPreviewController ()

@end

@implementation PhotoPreviewController

- (void)flushPhotos
{
    [_delegate flushPhotos];
}

- (id)initWithDelegate:(id<PhotoPreviewControllerDelegate>) delegate
{
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        _isDelete = NO;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:{
            if (buttonIndex == 1) {
                UITextField *textField = [alertView textFieldAtIndex:0];
                [self.delegate renameItem:self.item withName:textField.text];
                self.navigationItem.title = self.item.name;
            }
        }break;
        case 10:{
            //密码输入
            if (buttonIndex == 1) {
                UITextField *tf0 = [alertView textFieldAtIndex:0];
                UITextField *tf1 = [alertView textFieldAtIndex:1];
                
                if (tf0.text == nil || [tf0.text isEqualToString:@""] || tf1.text == nil || [tf1.text isEqualToString:@""]) {
                    //密码不能等于空
                    [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Password can't be empty", @"Password can't be empty") message:NSLocalizedString(@"please enter password", @"please enter password") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles: nil];
                    
                } else if ([tf0.text isEqualToString:tf1.text]) {
                    //设置密码
                    self.item.password = tf0.text;
                    [self.delegate updateItemWithName:self.item.name];
                    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Remove password", @"Remove password");
                    
                } else {
                    
                    [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Two passwords different", @"Two passwords different") message:NSLocalizedString(@"Please enter again", @"Please enter again") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
                }
            }
        }break;
        case 20:{
            //取消密码
            if (buttonIndex == 1) {
                UITextField *tf0 = [alertView textFieldAtIndex:0];
                if ([tf0.text isEqualToString:self.item.password]) {
                    self.item.password = nil;
                    [self.delegate updateItemWithName:self.item.name];
                    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Set password", @"Set password");
                }
            }
        }break;
        case 50:{
            if (buttonIndex == 1) {
                NSString *text0 = [alertView textFieldAtIndex:0].text;
                if ([text0 isEqual:@""]) {
                    [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Move failed", @"Move failed") message:NSLocalizedString(@"New folder name can't be empty", @"New folder name can't be empty") delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
                } else if([_delegate addItemWithName:text0]) {
                    //移动到新建文件夹
                    //创建文件夹成功
                    SBItem *target = [_delegate itemWithName:text0];
                    for (int i = 0; i < _toUpdateFiles.count; i++) {
                        [target addFileFromOther:[_toUpdateFiles objectAtIndex:i]];
                        [_item removeFileAtIndex:i];
                    }
                    [_toUpdateFiles removeAllObjects];
                    [_toUpdatePreviews removeAllObjects];
                    [self flushPhotos];
                    [self updateScrollView];
                }
            }
        }break;
//        case 0:{
//            
//        }break;
            
        default:
            break;
    }
}

- (void)cancelUpdate
{
    _isUpdate = NO;
    
    self.navigationItem.leftBarButtonItem = self.left;
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Set password", @"Set password");
    self.navigationItem.title = self.item.name;
    for (int i = 0; i < _toUpdatePreviews.count; i++) {
        UIView *view = [_toUpdatePreviews objectAtIndex:i];
        for (UIView *v  in [view subviews]) {
            [v removeFromSuperview];
        }
    }
}

- (void)cancelDelete
{
    //取消
    _isDelete = NO;
    self.navigationItem.leftBarButtonItem = self.left;
    self.navigationItem.title = self.item.name;
    if (self.item.password) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Remove password", @"Remove password");
    } else {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Set password", @"Set password");
    }
    
    for (int i = 0; i < _toDeletePreViews.count; i++) {
        UIView *view = [_toDeletePreViews objectAtIndex:i];
        for (UIView *v  in [view subviews]) {
            [v removeFromSuperview];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _sheetButtonIndex = buttonIndex;
    self.navigationItem.title = NSLocalizedString(@"Click to select", @"Click to select");
    self.navigationItem.rightBarButtonItem.title = (_sheetButtonIndex==0) ? NSLocalizedString(@"Upload", @"Upload"): NSLocalizedString(@"Move", @"Move");
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    left.tag = 0;
    self.navigationItem.leftBarButtonItem = left;
    [_toUpdatePreviews removeAllObjects];
    [_toUpdateFiles removeAllObjects];
    _isUpdate = YES;
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [_toUpdatePreviews removeLastObject];
    if (_toUpdatePreviews.count == 0) {
        NSString *msg = nil ;
        if(error != NULL){
            msg = @"保存图片失败" ;
        }else{
            msg = @"保存图片成功" ;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"result"
//                                                        message:msg
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure")
//                                              otherButtonTitles:nil];
//        [alert show];
        [_toUpdateFiles removeAllObjects];
    }
}


- (void)bbiAction:(UIBarButtonItem *)item
{
    switch (item.tag) {
        case 0:{
            
            if (_isDelete) {
                //取消
                [self cancelDelete];
            } else if (_isUpdate) {
            
                //goto 其他取消上传
                [self cancelUpdate];
            } else {
                //back
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }break;
        case 10:{
            
            if (_isDelete) {
                //删除
                if (_toDeletePreViews.count == 0) {
                    [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Please select at least oen photo", @"Please select at least oen photo") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
                    return;
                }
                for (int i = 0; i < _toDeletePreViews.count; i++) {
                    UIView *view = [_toDeletePreViews objectAtIndex:i];
                    [_item removeFileAtIndex:[_previews indexOfObject:view]];
                    [view removeFromSuperview];
                }
                [self.delegate updateItemWithName:self.item.name];
                [_toDeletePreViews removeAllObjects];
            } else if (_isUpdate) {
                //上传
                if (_toUpdatePreviews.count == 0) {
                    [KTUIFactory showAlertViewWithTitle:NSLocalizedString(@"Please select at least oen photo", @"Please select at least oen photo") message:nil delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"Sure", @"Sure") otherButtonTitles:nil];
                    return;
                }
        
                for (int i = 0; i < _toUpdatePreviews.count; i++) {
                    UIView *view = [_toUpdatePreviews objectAtIndex:i];
                    NSString *file = [self.item.files objectAtIndex:[_previews indexOfObject:view]];
                    
                    [_toUpdateFiles addObject:file];
                        //系统相册
                    
                    if (_sheetButtonIndex == 0) {
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:file], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    }
        
                    for (UIView *v in [view subviews]) {
                        [v removeFromSuperview];
                    }
                }
                
                if (_sheetButtonIndex == 1) {
                    PhotoMoveController *vc = [[PhotoMoveController alloc] initWithDelegate:self];
                    
                    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[_delegate allItems]];
                    [array removeObject:_item];
                    vc.dataArray = array;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (_sheetButtonIndex == 2) {
                    
                    [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Move files to new folder", @"Move files to new folder") delegate:self tag:50 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
                }
            } else {
                
                if (self.item.password) {
                    //取消密码
                    [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Please enter old password", @"Please enter old password") delegate:self tag:20 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
                } else {
                    //设置密码
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"please enter password", @"please enter password") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
                    view.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                    UITextField *tf0 = [view textFieldAtIndex:0];
                    UITextField *tf1 = [view textFieldAtIndex:1];
                    tf0.placeholder = NSLocalizedString(@"Password", @"Password");
                    tf0.secureTextEntry = YES;
                    tf1.placeholder = NSLocalizedString(@"Repeat password", @"Repeat password");
                    tf1.secureTextEntry = YES;
                    view.tag = 10;
                    [view show];
                }
            }
        }break;
        case 100:{
            //upload
            [self cancelDelete];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Handle multiple photos", @"Handle multiple photos") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Upload files to system album", @"Upload files to system album"), NSLocalizedString(@"Move select files to exit folder", @"Move select files to exit folder"), NSLocalizedString(@"Move select files to new folder", @"Move select files to new folder"), nil];
            [sheet showInView:self.view];
        }break;
        case 110:{
            //download
            [self cancelDelete];
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = NO;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            picker.wantsFullScreenLayout = NO;
            [self presentModalViewController:picker animated:YES];

        }break;
        case 120:{
            //photo
            [self cancelDelete];
            [self openCamera];
        }break;
        case 130:{
            //edit
            [self cancelDelete];
            [KTUIFactory showTextFieldAlertViewWithTitle:NSLocalizedString(@"Please input new folder name", @"Please input new folder name") delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Sure", @"Sure"), nil];
        }break;
        case 140:{
            //delete
            _isDelete = YES;
            
            if (_isDelete) {
                self.navigationItem.title = NSLocalizedString(@"Click to select", @"Click to select");
                [_toDeletePreViews removeAllObjects];
                UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
                left.tag = 0;
                self.navigationItem.leftBarButtonItem = left;
                self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Delete", @"Delete");
            }
            
        }break;
        default:
            break;
    }
}

- (void)openCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    BOOL isCameraValid = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    //判断iOS7的宏，没有就自己写个，下边的方法是iOS7新加的，7以下调用会报错
    if(IS_iOS7)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized)
        {
            isCameraValid = NO;
        } else {
            isCameraValid = YES;
        }
    }
    if (!isCameraValid) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Cant't have access to the camera,please go to privacy and enable camera function" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    imagePicker.sourceType = sourceType;//获取类型是摄像头，还可以是相册
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    imagePicker.allowsEditing = NO;//如果为NO照出来的照片是原图，比如4s和5的iPhone出来的尺寸应该是（2000+）*（3000+），差不多800W像素，如果是YES会有个选择区域的方形方框
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.showsCameraControls = YES;//默认是打开的这样才有拍照键，前后摄像头切换的控制，一半设置为NO的时候用于自定义ovelay
    }
    
    
//    imagePicker.cameraOverlayView ;//3.0以后可以直接设置cameraOverlayView为overlay
    
    imagePicker.wantsFullScreenLayout = NO;
    
    [self presentModalViewController:imagePicker animated:YES];
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
    
    UIBarButtonItem *flexibleSpaceItem;
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    UIBarButtonItem *upload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_upload"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    upload.tag = 100;
    [items addObject:upload];
    
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    
    UIBarButtonItem *download = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_download"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    download.tag = 110;
    [items addObject:download];
    
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    UIBarButtonItem *photo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    photo.tag = 120;
    [items addObject:photo];
    
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_modify"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    edit.tag = 130;
    [items addObject:edit];
    
    
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    delete.tag = 140;
    [items addObject:delete];
    
    flexibleSpaceItem = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:self
                         action:NULL];
    [items addObject:flexibleSpaceItem];
    
    
    [toolBar setItems:items];
    
    CGRect rect = toolBar.frame;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        rect.origin.y = rect.origin.y-90;
    } else {
        rect.origin.y = rect.origin.y-50;
    }
    
    toolBar.frame = rect;
}

- (void)createScrollView
{
//    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.winSize.width, self.winSize.height - 44 - 44)];
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(self.winSize.width, self.winSize.height);
    scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.previews = [[NSMutableArray alloc] init];
    self.toDeletePreViews = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tgc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [scrollView addGestureRecognizer:tgc];
}

- (void)updateScrollView
{
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    NSLog(@"self.item.files = %@", self.item.files);
    
    int wd = floor(self.view.frame.size.width / 79.0);
    int ht = floor(self.view.frame.size.height / 79.0);
    
    int fileCount = self.item.files.count;
    int yCount = fileCount/wd;
    if (yCount > ht) {
        self.scrollView.contentSize = CGSizeMake(self.winSize.width, yCount * 79);
    } else {
        self.scrollView.contentSize = self.winSize;
    }
    [_previews removeAllObjects];
    
    for (int i = 0; i < self.item.files.count; i++) {
        int dx = i % wd;
        int dy = i / wd;
        
        UIImage *image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:[self.item.files objectAtIndex:i]] scaleToSize:CGSizeMake(75, 75)];
        
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        [_previews addObject:view];
        [self.scrollView addSubview:view];
        view.center = CGPointAdd(CGPointMult(CGPointMake(dx , dy), 79), CGPointMake(41.5, 41.5));
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tgr
{
    CGPoint point = [tgr locationInView:self.scrollView];
    if (self.isDelete) {
        
        for (int i = 0; i < _previews.count; i++) {
            UIImageView *view = [_previews objectAtIndex:i];
            if (CGRectContainsPoint(view.frame, point)) {
                
                if ([_toDeletePreViews containsObject:view]) {
                    //已经选中 反选
                    [_toDeletePreViews removeObject:view];
                    for (UIView *v in [view subviews]) {
                        [v removeFromSuperview];
                    }
                } else {
                    //未选中
                    [_toDeletePreViews addObject:view];
                    UIView *mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Overlay"]];
                    [view addSubview:mask];
                }
                break;
            }
        }
    } else if (_isUpdate) {
        //上传
        for (int i = 0; i < _previews.count; i++) {
            UIImageView *view = [_previews objectAtIndex:i];
            if (CGRectContainsPoint(view.frame, point)) {
                
                if ([_toUpdatePreviews containsObject:view]) {
                    //已经选中 反选
                    [_toUpdatePreviews removeObject:view];
                    for (UIView *v in [view subviews]) {
                        [v removeFromSuperview];
                    }
                } else {
                    //未选中
                    [_toUpdatePreviews addObject:view];
                    UIView *mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Overlay"]];
                    [view addSubview:mask];
                }
                
                break;
            }
        }
    } else {
        for (int i = 0; i < _previews.count; i++) {
            UIImageView *view = [_previews objectAtIndex:i];
            if (CGRectContainsPoint(view.frame, point)) {
                
                PhotoDetailController *vc = [[PhotoDetailController alloc] init];
                vc.photos = self.item.files;
                vc.photoIndex = i;
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isUpdate = NO;
    
    self.item = [self.delegate itemWithName:self.navigationItem.title];

    self.left = self.navigationItem.leftBarButtonItem;
    self.left.tag = 0;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:self.item.password ? NSLocalizedString(@"Remove password", @"Remove password") : NSLocalizedString(@"Set password", @"Set password") style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction:)];
    right.tag = 10;
    self.navigationItem.rightBarButtonItem = right;
    
    [self createScrollView];
    [self createToolBar];
    self.toUpdatePreviews = [NSMutableArray array];
    self.toUpdateFiles = [NSMutableArray array];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"dict = %@", info);
    if (![picker.class isSubclassOfClass:[UIImagePickerController class]]) {
        return;
    }
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //拍照
        UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];//可以打印一下这个info，如果用的是可编辑的，那就获取editedImage,不是OriginalImage
        NSLog(@"%f, %f", image.size.height,image.size.width);
        NSData *data = UIImageJPEGRepresentation(image, 1);//转换成JPEG编码
    
        [_item addNewFileWithData:data];
    
        [self updateScrollView];
        
        [self.delegate updateItemWithName:self.item.name];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
//    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}




@end
