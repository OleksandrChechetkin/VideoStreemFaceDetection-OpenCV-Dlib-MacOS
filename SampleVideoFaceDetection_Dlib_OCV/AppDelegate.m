//
//  AppDelegate.m
//  SampleVideoFaceDetection_Dlib_OCV
//
//  Created by Alex Chechetkin on 05.01.2020.
//  Copyright © 2020 Alex Chechetkin. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "ComputerVision.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ComputerVision instance] run];
            });
        }
    }];
}

- (void)setComputerVisionModeBlur {
    [[ComputerVision instance] setVideoMode:VideoModeBlur];
}

- (void)setComputerVisionModeChange {
    [[ComputerVision instance] setVideoMode:VideoModeChange];
}

- (void)setComputerVisionCropModeFace {
    [[ComputerVision instance] setCropMode:CropModeFace];
}

- (void)setComputerVisionCropModeCircle {
    [[ComputerVision instance] setCropMode:CropModeCircle];
}

- (void)setComputerVisionOptimizationModeSpeed {
    [[ComputerVision instance] setOptimizationMode:OptimizationModeSpeed];
}

- (void)setComputerVisionOptimizationModeAccuracy {
    [[ComputerVision instance] setOptimizationMode:OptimizationModeAccuracy];
}

@end
