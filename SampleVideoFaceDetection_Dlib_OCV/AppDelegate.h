//
//  AppDelegate.h
//  SampleVideoFaceDetection_Dlib_OCV
//
//  Created by Alex Chechetkin on 05.01.2020.
//  Copyright © 2020 Alex Chechetkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)setComputerVisionModeBlur;
- (void)setComputerVisionModeChange;
- (void)setComputerVisionCropModeFace;
- (void)setComputerVisionCropModeCircle;
- (void)setComputerVisionCropModeMouth;
- (void)setComputerVisionOptimizationModeSpeed;
- (void)setComputerVisionOptimizationModeAccuracy;
    
@end

