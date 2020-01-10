//
//  ViewController.m
//  SampleVideoFaceDetection_Dlib_OCV
//
//  Created by Alex Chechetkin on 05.01.2020.
//  Copyright © 2020 Alex Chechetkin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (IBAction)onVideoModeDropDownValueChanged:(NSPopUpButton *)sender {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    if (sender.selectedTag == 1) {
        [delegate setComputerVisionModeBlur];
    } else {
        [delegate setComputerVisionModeChange];
    }
}

- (IBAction)onCropDropDownValueChanged:(NSPopUpButton *)sender {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    if (sender.selectedTag == 1) {
        [delegate setComputerVisionCropModeFace];
    } else if (sender.selectedTag == 2) {
        [delegate setComputerVisionCropModeCircle];
    } else {
        [delegate setComputerVisionCropModeMouth];
    }
}

- (IBAction)onOptimizationModeChanged:(NSPopUpButton *)sender {
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    if (sender.selectedTag == 1) {
        [delegate setComputerVisionOptimizationModeSpeed];
    } else {
        [delegate setComputerVisionOptimizationModeAccuracy];
    }
}

@end
