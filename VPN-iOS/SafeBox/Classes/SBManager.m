//
//  SBManager.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SBManager.h"
#import "SBConfig.h"

@implementation SBManager

- (id)init
{
    self = [super init];
    if (self) {
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
//        [fm createDirectoryAtPath:PhotoPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fm createDirectoryAtPath:VedioPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createDirectoryAtPath:PhotosPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createDirectoryAtPath:VideosPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:AccountPath];
        
        if (!dict) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *cx = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"",@"pw",
                                array, @"records",nil];
            array = [[NSMutableArray alloc] init];
            NSMutableDictionary *xy = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"", @"pw",
                                array, @"records", nil];
            
            array = [[NSMutableArray alloc] init];
            NSMutableDictionary *yx = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"", @"pw",
                                array, @"records", nil];
            array = [[NSMutableArray alloc] init];
            NSMutableDictionary *wz = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"", @"pw",
                                array, @"records", nil];
            
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    cx, @"cx",
                    xy, @"xy",
                    yx, @"yx",
                    wz, @"wz",nil];
            
            [dict writeToFile:AccountPath atomically:YES];
        }
        self.accountDict = dict;
    }
    return self;
}

- (void)flushAccount
{
    [_accountDict writeToFile:AccountPath atomically:YES];
}

+ (SBManager *)sharedManaegr
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[SBManager alloc] init];
    });
    return _sharedObject;
}

@end
