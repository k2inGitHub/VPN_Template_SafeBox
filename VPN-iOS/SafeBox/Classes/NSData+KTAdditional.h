//
//  NSData+KTAdditional.h
//  VideoPlay
//
//  Created by SongYang on 13-10-25.
//
//

#import <Foundation/Foundation.h>

@interface NSData (KTAdditional)

/*伪装二进制文件*/

+ (NSData *)maskEncode:(NSData *)data;
+ (NSData *)maskDecode:(NSData *)data;

@end

@interface UIImage (KTAdditional)

///通过加密文件创建UIImage
+ (UIImage *)imageMaskPath:(NSString *)path;
///调整image大小
+ (UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize) size;

@end
