//
//  SBConfig.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#ifndef SafeBox_SBConfig_h
#define SafeBox_SBConfig_h


/**
 log
 删除文件夹后 修改别的文件夹为它时报错
 
 */



#define IS_iOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0


#define DucumentPath    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define BundlePath      [[NSBundle mainBundle] bundlePath]
#define LibraryPath     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define LibCachePath    [LibraryPath stringByAppendingPathComponent:@"Caches"]
#define LibPrefPath     [LibraryPath stringByAppendingPathComponent:@"Preference"]

//#define PhotoPath       [LibCachePath stringByAppendingPathComponent:@"SBPhoto"]

//#define VedioPath       [LibCachePath stringByAppendingPathComponent:@"SBVedio"]

//#define PhotoArchiveFile    [PhotoPath stringByAppendingPathComponent:@"PhotoAR.plist"]

//#define VedioArchiveFile    [VedioPath stringByAppendingPathComponent:@"VedioAR.plist"]

#define PhotosPath          [LibCachePath stringByAppendingPathComponent:@"SBPhotos"]

#define SBPhotoArchiveFile  [LibCachePath stringByAppendingPathComponent:@"Photo.plist"]

#define SBVedioArchiveFile  [LibCachePath stringByAppendingPathComponent:@"Vedio.plist"]

#define VideosPath          [LibCachePath stringByAppendingPathComponent:@"SBVideos"]

#define AccountPath         [LibCachePath stringByAppendingPathComponent:@"SBAccount.plist"]


#endif
