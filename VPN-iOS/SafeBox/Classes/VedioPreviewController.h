//
//  VedioPreviewController.h
//  SafeBox
//
//  Created by SongYang on 14-3-19.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewController.h"
#import "SBItem.h"
#import "UIImagePickerController+RemoveStatusBar.h"
#import "PhotoMoveController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol VedioPreviewControllerDelegate <NSObject>

- (void)deleteItemWithName:(NSString *)name;

- (void)updateItemWithName:(NSString *)name;

- (BOOL)addItemWithName:(NSString *)name;

- (SBItem *)itemWithName:(NSString *)name;

- (BOOL)renameItem:(SBItem *)item withName:(NSString *)name;

- (NSMutableArray *)allItems;

- (void)flushPhotos;

@end

@interface VedioPreviewController : KTViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, PhotoMoveControllerDelegate>

@property (nonatomic, strong) MPMoviePlayerController *mp;

@property (nonatomic, strong) NSMutableArray *previews;

@property (nonatomic, strong) NSMutableArray *toDeletePreViews;

@property (nonatomic, strong) NSMutableArray *toUpdatePreviews;

@property (nonatomic, strong) NSMutableArray *toUpdateFiles;

@property (nonatomic, strong) UIBarButtonItem *left;

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SBItem *item;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, assign) BOOL isUpdate;

@property (nonatomic, assign) BOOL sheetButtonIndex;

@property (nonatomic, assign) id<VedioPreviewControllerDelegate> delegate;

- (id)initWithDelegate:(id<VedioPreviewControllerDelegate>) delegate;

- (void)flushPhotos;

@end
