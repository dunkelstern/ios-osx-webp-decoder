/* @file NSImage+WebP.h
 * @brief WebP loader for NSImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */

#import "decode.h"
#import "NSImage+WebP.h"
#import "CGImage+WebP.h"

#if !defined(TARGET_OS_IPHONE) && !defined(TARGET_IPHONE_SIMULATOR)

@implementation NSImage (WebP)

+ (instancetype)imageWithWebPNamed:(NSString *)name {
    NSString *filename = [[NSBundle mainBundle] pathForResource:imageName ofType:@"webp"];
    return [self imageWithWebPFile:filename];
}

+ (instancetype)imageWithWebPFile:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:nil]) {
        return nil;
    }

    NSData *imageData = [NSData dataWithContentsOfFile:path];

    CGImageRef imageRef = CGImageFromWebPData((__bridge CFDataRef)(imageData));
    NSImage *image = [NSImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return image;
}

@end

#endif