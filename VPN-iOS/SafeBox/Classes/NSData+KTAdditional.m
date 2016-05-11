//
//  NSData+KTAdditional.m
//  VideoPlay
//
//  Created by SongYang on 13-10-25.
//
//

#import "NSData+KTAdditional.h"

@implementation NSData (KTAdditional)

//伪装key
#define MASK    "syyxfysys"
//key长度
#define BITS    strlen(MASK)

+ (NSData *)maskEncode:(NSData *)data
{
    char buffer[32768];
    memset(buffer, 0, sizeof(buffer));
    sprintf(buffer, MASK);
    NSData *hData = [NSData dataWithBytes:buffer length:BITS];
    NSMutableData *retData = [NSMutableData dataWithData:hData];
    [retData appendData:data];
    return retData;
}

+ (NSData *)maskDecode:(NSData *)data
{
    NSMutableData *mData = [NSMutableData dataWithData:data];
    return [mData subdataWithRange:NSMakeRange(BITS, [mData length]-BITS)];
}

@end


@implementation UIImage (KTAdditional)


+ (UIImage *)imageMaskPath:(NSString *)path
{
    NSData *imgData = [NSData maskDecode:[NSData dataWithContentsOfFile:path]];
    NSLog(@"imgData = %@", imgData);
    return [UIImage imageWithData:imgData];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
