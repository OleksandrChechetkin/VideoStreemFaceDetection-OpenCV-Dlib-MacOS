//
//  ComputerVision.h
//  CX_CV
//
//  Created by Alex Chechetkin on 01.12.2019.
//  Copyright © 2019 Alex Chechetkin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    VideoModeBlur,
    VideoModeChange
} VideoMode;

typedef enum {
    CropModeFace,
    CropModeCircle,
    CropModeMouth
} CropMode;

typedef enum {
    OptimizationModeSpeed,
    OptimizationModeAccuracy
} OptimizationMode;

@interface ComputerVision : NSObject

+ (instancetype) instance;

- (void) run;
- (void) setVideoMode:(VideoMode) mode;
- (void) setCropMode:(CropMode) mode;
- (void) setOptimizationMode:(OptimizationMode) mode;

@end

NS_ASSUME_NONNULL_END
