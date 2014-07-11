/* @file UIImage+WebP.h
 * @brief WebP loader for UIImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */

#include "TargetConditionals.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

@interface UIImage (WebP)

/** @brief load image by name, extension is assumed to be "webp" and location is in the main bundle
 *
 *  @note if there is a @2x version of an image and the main screen is a retina screen this version
 *        will be loaded, modifiers like '~ipad' or '~iphone' do not work currently.
 *  @param name the name of the image to load
 *  @returns new UIImage containing the decoded webp image
 */
+ (instancetype)imageWithWebPNamed:(NSString *)name;

@end

#endif