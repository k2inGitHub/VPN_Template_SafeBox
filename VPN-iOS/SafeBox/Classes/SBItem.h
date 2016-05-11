//
//  SBItem.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBItem : NSObject<NSCoding>


//视频还是图片 0图片 1视频
@property (nonatomic, assign) int type;

//名字
@property (nonatomic, copy) NSString *name;

//名字
@property (nonatomic, assign) int full;

//照片文件路径数组
@property (nonatomic, strong) NSMutableArray *files;

//密码
@property (nonatomic, copy) NSString *password;

//对文件重新排序
- (void)resortAllFiles;

- (void)removeFile:(NSString *)file;
//删除一个照片路径 和照片文件
- (void)removeFileAtIndex:(int)index;
//增加一个照片路径 和照片文件
- (void)addFileFromOther:(NSString *)file;

//jpg
- (void)addNewFileWithData:(NSData *)jpgData;

//mp4
- (void)addNewFileWithUrl:(NSURL *)videoURL;

@end
