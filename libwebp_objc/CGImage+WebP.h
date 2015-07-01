/* @file CGImage+WebP.h
 * @brief WebP loader for CGImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */

@import Foundation;
@import CoreGraphics;

/* @brief load WebP image data and create a CGImage from it
 *
 * @param data data to decode
 * @returns CGImage with decoded data or NULL, result has to be freed with CGImageRelease()
 */
CGImageRef CGImageFromWebPData(CFDataRef data);

