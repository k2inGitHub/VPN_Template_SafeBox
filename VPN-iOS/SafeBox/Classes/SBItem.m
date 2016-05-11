//
//  SBItem.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SBItem.h"
#import "SBConfig.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define Path    (self.type == 0 ? PhotosPath : VideosPath)
#define Ext     (self.type == 0 ? @"jpg" : @"mov")
@implementation SBItem

//对文件重新排序 重新命名
- (void)resortAllFiles
{
    NSFileManager *fm = [NSFileManager defaultManager];
    for (int i = 0; i < _files.count; i++) {
        NSString *file = [_files objectAtIndex:i];
        NSString *newFile = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@", _name, i, Ext]];
        if (![file isEqualToString:newFile]) {
            [_files replaceObjectAtIndex:i withObject:newFile];
            [fm moveItemAtPath:file toPath:newFile error:nil];
        }
    }
}
- (void)removeFile:(NSString *)file
{
    int index = -1;
    for (int i = 0;i < _files.count; i++) {
        if ([file isEqualToString:[_files objectAtIndex:i]]) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [self removeFileAtIndex:index];
    } else {
        NSLog(@"未找到删除的文件");
    }
}

//删除一个照片路径 和照片文件
- (void)removeFileAtIndex:(int)index;
{
    NSString *file = [_files objectAtIndex:index];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:file error:nil];
    [_files removeObject:file];
    [self resortAllFiles];
}
//增加一个照片路径 和照片文件
- (void)addFileFromOther:(NSString *)file
{
    NSString *newFile = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@", _name, _files.count, Ext]];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm copyItemAtPath:file toPath:newFile error:nil];
    [_files addObject:newFile];
}

- (void)addNewFileWithUrl:(NSURL *)videoURL
{
    NSString *file = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@", _name, _files.count, Ext]];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *videoPath = [videoURL absoluteString];
    if ([fm fileExistsAtPath:videoPath]) {
        [fm removeItemAtPath:videoPath error:nil];
    }
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
        
    {
        
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSLog(@"target url = %@", file);
        exportSession.outputURL = [NSURL fileURLWithPath: file];
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"Successful!");

                    [_files addObject:file];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBItem_ExportFinish" object:nil];

                    break;
                }
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
- (void)addNewFileWithData:(NSData *)jpgData
{
    
    NSString *file = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@", _name, _files.count, Ext]];
    [_files addObject:file];
    [jpgData writeToFile:file atomically:YES];
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_type forKey:@"type"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_files forKey:@"files"];
    [aCoder encodeObject:_password forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        NSArray *array = [aDecoder decodeObjectForKey:@"files"];
    
        self.files = [[NSMutableArray alloc] initWithArray:array];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.type = [aDecoder decodeIntForKey:@"type"];
        
//        NSLog(@"item name = %@", self.name);
//        NSLog(@"item files = %@", self.files);
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.name = nil;
        self.password = nil;
        self.files = [[NSMutableArray alloc] init];
        self.full = 0;
    }
    return self;
}

@end
