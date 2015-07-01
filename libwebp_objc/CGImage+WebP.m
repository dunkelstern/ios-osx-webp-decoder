/* @file CGImage+WebP.c
 * @brief WebP loader for CGImage
 *
 * @version 1.0
 * @author Johannes Schriewer <hallo@dunkelstern.de>
 * @date 2014-07-10
 */


#import "CGImage+WebP.h"
#import "decode.h"

/** @brief callback function of CoreGraphics to free underlying memory */
static void free_data(void *info, const void *data, size_t size) {
    if(info != NULL) {
        WebPFreeDecBuffer(&(((WebPDecoderConfig *)info)->output));
        free(info);
    } else {
        free((void *)data);
    }
}

CGImageRef CGImageFromWebPData(CFDataRef data) {
    CFRetain(data);

    // fetch size of image
    int width = 0;
    int height = 0;
    WebPGetInfo(CFDataGetBytePtr(data), CFDataGetLength(data), &width, &height);

    if ((width == 0) || (height == 0)) {
        return NULL; // could not read image
    }

    // Configure decoder
    WebPDecoderConfig *config = malloc(sizeof(WebPDecoderConfig));
    WebPInitDecoderConfig(config);

#if defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR)
    // speed on iphone
    config->options.no_fancy_upsampling = 1;
#else
    // quality on mac
    config->options.no_fancy_upsampling = 0;
#endif
    config->options.bypass_filtering = 0;
    config->options.use_threads = 1;
    config->output.colorspace = MODE_RGBA;

    // decode image
    WebPDecode(CFDataGetBytePtr(data), CFDataGetLength(data), config);

    // create image provider on output of webp decoder
    CGDataProviderRef provider = CGDataProviderCreateWithData(config, config->output.u.RGBA.rgba, width*height*4, free_data);;

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    // create cgimage from the provider, use stride from the decoder
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, config->output.u.RGBA.stride, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);

    // clean up
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    CFRelease(data);

    return imageRef;
}
