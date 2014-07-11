//
//  ViewController.m
//  webptest
//
//  Created by Johannes Schriewer on 10.07.14.
//  Copyright (c) 2014 planetmutlu. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+WebP.h"
#import "CGImage+WebP.h"

#import <ImageIO/ImageIO.h>

// benchmark
#include <mach/mach_time.h>
#include <stdint.h>

CGImageRef CGImageFromJPEGData(CFDataRef data) {
    CFRetain(data);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, CFDataGetBytePtr(data), CFDataGetLength(data), NULL);;
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);

    NSDictionary *options = @{(NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                              (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                             };
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)options);
    CFRelease(source);
    CFRelease(provider);
    CFRelease(data);
    return imageRef;
}


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *yolo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.yolo.image = [UIImage imageWithWebPNamed:@"4"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)benchmarkPressed:(id)sender {
    NSString *webPFile = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"webp"];
    NSData *webPData = [NSData dataWithContentsOfFile:webPFile];


    uint64_t startTime = mach_absolute_time();
    for (NSInteger i=0; i < 100; i++) {
        CGImageRef img = CGImageFromWebPData((__bridge CFDataRef)(webPData));
        CGImageRelease(img);
    }

    uint64_t endTime = mach_absolute_time();
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);

    double elapsedNSWebP = (double)(endTime - startTime) * (double)info.numer / (double)info.denom;
    NSLog(@"Decoding WebP 100 times: %f ms", elapsedNSWebP / 1000.0 / 1000.0);

    NSString *jpegFile = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"];
    NSData *jpegData = [NSData dataWithContentsOfFile:jpegFile];

    startTime = mach_absolute_time();
    for (NSInteger i = 0; i < 100; i++) {
        CGImageRef img = CGImageFromJPEGData((__bridge CFDataRef)(jpegData));
        CGImageRelease(img);
    }
    endTime = mach_absolute_time();

    double elapsedNSJPEG = (double)(endTime - startTime) * (double)info.numer / (double)info.denom;
    NSLog(@"Decoding JPEG 100 times: %f ms", elapsedNSJPEG / 1000.0 / 1000.0);
}

@end
