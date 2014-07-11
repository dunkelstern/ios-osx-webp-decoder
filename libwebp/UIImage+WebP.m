/* @file UIImage+WebP.m
 * @brief WebP loader for UIImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */

#import "decode.h"
#import "UIImage+WebP.h"
#import "CGImage+WebP.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

@implementation UIImage (WebP)

+ (instancetype)imageWithWebPNamed:(NSString *)name {
    NSString *imageName = name;
    if ([[UIScreen mainScreen] scale] > 1.0) {
        imageName = [imageName stringByAppendingString:@"@2x"];
    }
    NSString *filename = [[NSBundle mainBundle] pathForResource:imageName ofType:@"webp"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:nil]) {
        if ([[UIScreen mainScreen] scale] > 1.0) {
            filename = [[NSBundle mainBundle] pathForResource:name ofType:@"webp"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:nil]) {
                return nil;
            }
        } else {
            return nil;
        }
    }

    NSData *imageData = [NSData dataWithContentsOfFile:filename];

    CGImageRef imageRef = CGImageFromWebPData((__bridge CFDataRef)(imageData));
    UIImage *uiImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return uiImage;
}

@end

#endif