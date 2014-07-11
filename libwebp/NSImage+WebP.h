/* @file NSImage+WebP.h
 * @brief WebP loader for NSImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */

#include "TargetConditionals.h"
#if !defined(TARGET_OS_IPHONE) && !defined(TARGET_IPHONE_SIMULATOR)

#import <AppKit/AppKit.h>

@interface NSImage (WebP)

/** @brief load image by name, extension is assumed to be "webp" and location is in the main bundle
 *
 *  @param name the name of the image to load
 *  @returns new NSImage containing the decoded webp image
 */
+ (instancetype)imageWithWebPNamed:(NSString *)name;

/** @brief load image by file path
 *
 *  @param path path to the image to load
 *  @returns new NSImage containing the decoded webp image
 */
+ (instancetype)imageWithWebPFile:(NSString *)path;

@end

#endif