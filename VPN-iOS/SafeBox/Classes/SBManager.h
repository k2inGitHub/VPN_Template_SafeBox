//
//  SBManager.h
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *accountDict;

- (void)flushAccount;

+ (SBManager *)sharedManaegr;

@end
