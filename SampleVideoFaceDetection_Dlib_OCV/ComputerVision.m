//
//  ComputerVision.m
//  ComputerVision
//
//  Created by Alex Chechetkin on 23.11.2019.
//  Copyright © 2019 Alex Chechetkin. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include "/usr/local/Cellar/dlib-19.17/dlib/image_processing.h"
#include <dlib/opencv.h>
#import "ComputerVision.h"

#define BLACK_FRAME(frame) cv::Mat(frame.rows, frame.cols, frame.type(), cv::Scalar(0, 0, 0))
#define OPTIMIZATION_SPEED 4
#define OPTIMIZATION_ACCURACY 1

typedef enum {
    PartTypeFace,
    PartTypeBackground
} PartType;

@interface ComputerVision() {
    dlib::frontal_face_detector faceDeterctor;
    dlib::shape_predictor shapePredictor5;
    dlib::shape_predictor shapePredictor68;

    cv::Mat skyBackgroundImage;
}

@property (nonatomic, assign) VideoMode videoMode;
@property (nonatomic, assign) CropMode cropMode;
@property (nonatomic, assign) OptimizationMode optimizationMode;
@property (nonatomic, assign) short optimizationCoeficient;

@end

@implementation ComputerVision

+ (instancetype) instance {
    static dispatch_once_t onceToken;
    static ComputerVision *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ComputerVision alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        faceDeterctor = dlib::get_frontal_face_detector();
        NSString *predictor5Path = [[NSBundle mainBundle] pathForResource:@"shape_predictor_5_face_landmarks" ofType:@"dat"];
        std::string shapeLandmarks5FilePath = std::string([predictor5Path UTF8String]);
        dlib::deserialize(shapeLandmarks5FilePath) >> shapePredictor5;
        
        NSString *predictor68Path = [[NSBundle mainBundle] pathForResource:@"shape_predictor_68_face_landmarks" ofType:@"dat"];
        std::string shapeLandmarks68FilePath = std::string([predictor68Path UTF8String]);
        dlib::deserialize(shapeLandmarks68FilePath) >> shapePredictor68;
        
        NSString *skyImagePath = [[NSBundle mainBundle] pathForResource:@"sky_bg" ofType:@"jpg"];
        std::string skyImageFilePath = std::string([skyImagePath UTF8String]);
        cv::Mat tempImg = cv::imread(skyImageFilePath, 1);
        cv::resize(tempImg, skyBackgroundImage, cv::Size(1280, 720));
        
        _optimizationCoeficient = OPTIMIZATION_SPEED;
        _optimizationMode = OptimizationModeSpeed;
        _videoMode = VideoModeChange;
        _cropMode = CropModeCircle;
    }
    return self;
}

- (void) setOptimizationMode:(OptimizationMode) mode {
    _optimizationMode = mode;
    self.optimizationCoeficient = (mode == OptimizationModeSpeed) ? OPTIMIZATION_SPEED : OPTIMIZATION_ACCURACY;
}

- (dlib::full_object_detection) getFaceDetectionForFrame:(cv::Mat *)frame
                                                extended:(BOOL)extended {
    dlib::full_object_detection result;
    cv::Mat rgbFrame;
    cv::cvtColor(*frame, rgbFrame, cv::COLOR_RGBA2RGB);
    dlib::array2d<dlib::rgb_pixel> dlibImg;
    cv::Mat rgbFrameSized;
    cv::resize(rgbFrame, rgbFrameSized, cv::Size(rgbFrame.cols/_optimizationCoeficient, rgbFrame.rows/_optimizationCoeficient));
    dlib::assign_image(dlibImg, dlib::cv_image<dlib::rgb_pixel>(rgbFrameSized));
    std::vector<dlib::rectangle> dets = faceDeterctor(dlibImg);
    
    if (dets.size() > 0) {
        dlib::rectangle detectedFace = dets[0];
        result = extended ? shapePredictor68(dlibImg, detectedFace) : shapePredictor5(dlibImg, detectedFace);
    }
    
    return result;
}

- (void) extractPart:(PartType)part
           fromFrame:(cv::Mat *)frame
   withFaceDetection:(dlib::full_object_detection *)detection
             toFrame:(cv::Mat *)output {
    if (_cropMode == CropModeFace || _cropMode == CropModeMouth) {
        int num_points;
        cv::Point face[1][28];
        if (_cropMode == CropModeFace) {
        num_points = 28;
        face[0][0] = cv::Point((int)detection->part(0).x()*_optimizationCoeficient, (int)detection->part(0).y()*_optimizationCoeficient);
        face[0][1] = cv::Point((int)detection->part(1).x()*_optimizationCoeficient, (int)detection->part(1).y()*_optimizationCoeficient);
        face[0][2] = cv::Point((int)detection->part(2).x()*_optimizationCoeficient, (int)detection->part(2).y()*_optimizationCoeficient);
        face[0][3] = cv::Point((int)detection->part(3).x()*_optimizationCoeficient, (int)detection->part(3).y()*_optimizationCoeficient);
        face[0][4] = cv::Point((int)detection->part(4).x()*_optimizationCoeficient, (int)detection->part(4).y()*_optimizationCoeficient);
        face[0][5] = cv::Point((int)detection->part(5).x()*_optimizationCoeficient, (int)detection->part(5).y()*_optimizationCoeficient);
        face[0][6] = cv::Point((int)detection->part(6).x()*_optimizationCoeficient, (int)detection->part(6).y()*_optimizationCoeficient);
        face[0][7] = cv::Point((int)detection->part(7).x()*_optimizationCoeficient, (int)detection->part(7).y()*_optimizationCoeficient);
        face[0][8] = cv::Point((int)detection->part(8).x()*_optimizationCoeficient, (int)detection->part(8).y()*_optimizationCoeficient);
        face[0][9] = cv::Point((int)detection->part(9).x()*_optimizationCoeficient, (int)detection->part(9).y()*_optimizationCoeficient);
        face[0][10] = cv::Point((int)detection->part(10).x()*_optimizationCoeficient, (int)detection->part(10).y()*_optimizationCoeficient);
        face[0][11] = cv::Point((int)detection->part(11).x()*_optimizationCoeficient, (int)detection->part(11).y()*_optimizationCoeficient);
        face[0][12] = cv::Point((int)detection->part(12).x()*_optimizationCoeficient, (int)detection->part(12).y()*_optimizationCoeficient);
        face[0][13] = cv::Point((int)detection->part(13).x()*_optimizationCoeficient, (int)detection->part(13).y()*_optimizationCoeficient);
        face[0][14] = cv::Point((int)detection->part(14).x()*_optimizationCoeficient, (int)detection->part(14).y()*_optimizationCoeficient);
        face[0][15] = cv::Point((int)detection->part(15).x()*_optimizationCoeficient, (int)detection->part(15).y()*_optimizationCoeficient);
        face[0][16] = cv::Point((int)detection->part(16).x()*_optimizationCoeficient, (int)detection->part(16).y()*_optimizationCoeficient);
        face[0][17] = cv::Point((int)detection->part(26).x()*_optimizationCoeficient, (int)detection->part(26).y()*_optimizationCoeficient);
        face[0][18] = cv::Point((int)detection->part(25).x()*_optimizationCoeficient, (int)detection->part(25).y()*_optimizationCoeficient);
        face[0][19] = cv::Point((int)detection->part(24).x()*_optimizationCoeficient, (int)detection->part(24).y()*_optimizationCoeficient);
        face[0][20] = cv::Point((int)detection->part(23).x()*_optimizationCoeficient, (int)detection->part(23).y()*_optimizationCoeficient);
        face[0][21] = cv::Point((int)detection->part(22).x()*_optimizationCoeficient, (int)detection->part(22).y()*_optimizationCoeficient);
        face[0][22] = cv::Point((int)detection->part(21).x()*_optimizationCoeficient, (int)detection->part(21).y()*_optimizationCoeficient);
        face[0][23] = cv::Point((int)detection->part(20).x()*_optimizationCoeficient, (int)detection->part(20).y()*_optimizationCoeficient);
        face[0][24] = cv::Point((int)detection->part(19).x()*_optimizationCoeficient, (int)detection->part(19).y()*_optimizationCoeficient);
        face[0][25] = cv::Point((int)detection->part(18).x()*_optimizationCoeficient, (int)detection->part(18).y()*_optimizationCoeficient);
        face[0][26] = cv::Point((int)detection->part(17).x()*_optimizationCoeficient, (int)detection->part(17).y()*_optimizationCoeficient);
        face[0][27] = cv::Point((int)detection->part(0).x()*_optimizationCoeficient, (int)detection->part(0).y()*_optimizationCoeficient);
        } else if (_cropMode == CropModeMouth) {
            num_points = 13;
            face[0][0] = cv::Point((int)detection->part(49).x()*_optimizationCoeficient, (int)detection->part(49).y()*_optimizationCoeficient);
            face[0][1] = cv::Point((int)detection->part(50).x()*_optimizationCoeficient, (int)detection->part(50).y()*_optimizationCoeficient);
            face[0][2] = cv::Point((int)detection->part(51).x()*_optimizationCoeficient, (int)detection->part(51).y()*_optimizationCoeficient);
            face[0][3] = cv::Point((int)detection->part(52).x()*_optimizationCoeficient, (int)detection->part(52).y()*_optimizationCoeficient);
            face[0][4] = cv::Point((int)detection->part(53).x()*_optimizationCoeficient, (int)detection->part(53).y()*_optimizationCoeficient);
            face[0][5] = cv::Point((int)detection->part(54).x()*_optimizationCoeficient, (int)detection->part(54).y()*_optimizationCoeficient);
            face[0][6] = cv::Point((int)detection->part(55).x()*_optimizationCoeficient, (int)detection->part(55).y()*_optimizationCoeficient);
            face[0][7] = cv::Point((int)detection->part(56).x()*_optimizationCoeficient, (int)detection->part(56).y()*_optimizationCoeficient);
            face[0][8] = cv::Point((int)detection->part(57).x()*_optimizationCoeficient, (int)detection->part(57).y()*_optimizationCoeficient);
            face[0][9] = cv::Point((int)detection->part(58).x()*_optimizationCoeficient, (int)detection->part(58).y()*_optimizationCoeficient);
            face[0][10] = cv::Point((int)detection->part(59).x()*_optimizationCoeficient, (int)detection->part(59).y()*_optimizationCoeficient);
            face[0][11] = cv::Point((int)detection->part(60).x()*_optimizationCoeficient, (int)detection->part(60).y()*_optimizationCoeficient);
            face[0][12] = cv::Point((int)detection->part(49).x()*_optimizationCoeficient, (int)detection->part(49).y()*_optimizationCoeficient);
        }
        
        const cv::Point* faceList[1] = { face[0] };

        int num_polygons = 1;
        int line_type = 8;
        
        cv::Mat mask(frame->rows, frame->cols, frame->type(),
                     part == PartTypeFace ? cv::Scalar(0, 0, 0) : cv::Scalar(255, 255, 255));
        cv::fillPoly(mask, faceList, &num_points, num_polygons,
                     part == PartTypeFace ? cv::Scalar(255, 255, 255) : cv::Scalar(0, 0, 0),
                     line_type);
        cv::bitwise_and(*frame, mask, *output);
        
    } else if (_cropMode == CropModeCircle) {
        cv::Point nose = cv::Point((int)detection->part(4).x()*_optimizationCoeficient, (int)detection->part(4).y()*_optimizationCoeficient);
        cv::Point rightEye((int)detection->part(0).x()*_optimizationCoeficient, (int)detection->part(0).y()*_optimizationCoeficient);
        cv::Point leftEye((int)detection->part(2).x()*_optimizationCoeficient, (int)detection->part(2).y()*_optimizationCoeficient);
        int coefitient = (std::abs(rightEye.y - nose.y) + std::abs(leftEye.y - nose.y)) / 2;
        
        cv::Mat mask(frame->rows, frame->cols, frame->type(), part == PartTypeFace ? cv::Scalar(0, 0, 0) : cv::Scalar(255, 255, 255));
        cv::ellipse(mask,
                    cv::Point(nose.x, nose.y - coefitient),
                    cv::Size(frame->cols / 5, frame->cols / 5),
                    0, 0, 360,
                    part == PartTypeFace ? cv::Scalar(255, 255, 255) : cv::Scalar(0, 0, 0),
                    -1, 8);
        cv::bitwise_and(*frame, mask, *output);
    }
}

- (void) blurFrame:(cv::Mat *)frame
           toFrame:(cv::Mat *)output {
    cv::GaussianBlur(*frame, *output, cv::Size(55, 55), 0, 0, 0);
}

- (void) run {
    cv::VideoCapture cap;
    if(cap.open(0)) {
        for(;;) {
            cv::Mat frame;
            cap >> frame;
            cv::Mat result;
            if (!frame.empty()) {
                auto detection = [self getFaceDetectionForFrame:&frame
                                                       extended:_cropMode == CropModeFace ||
                                                                _cropMode == CropModeMouth];
                if (detection.num_parts() > 0) {
                    cv::Mat foregroground;
                    [self extractPart:PartTypeFace
                            fromFrame:&frame
                    withFaceDetection:&detection
                              toFrame:&foregroground];

                    cv::Mat background;
                    if (_videoMode == VideoModeBlur) {
                        cv::Mat bluredFrame;
                        [self blurFrame:&frame
                                toFrame:&bluredFrame];
                        
                        [self extractPart:PartTypeBackground
                                fromFrame:&bluredFrame
                        withFaceDetection:&detection
                                  toFrame:&background];
                    } else {
                        [self extractPart:PartTypeBackground
                                fromFrame:&skyBackgroundImage
                        withFaceDetection:&detection
                                  toFrame:&background];
                    }
                    
                    cv::bitwise_or(background, foregroground, result);
                } else {
                    result = _cropMode == CropModeFace ? BLACK_FRAME(frame) : skyBackgroundImage;
                }
            } else {
                break;
            }

            cv::imshow("result", result);
            cv::waitKey(1);
        }
    }
}

@end
