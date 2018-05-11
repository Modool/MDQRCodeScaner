//
//  MDQRCodeScaner.h
//  MDQRCodeScaner
//
//  Created by xulinfeng on 2018/5/11.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//! Project version number for MDQRCodeScaner.
FOUNDATION_EXPORT double MDQRCodeScanerVersionNumber;

//! Project version string for MDQRCodeScaner.
FOUNDATION_EXPORT const unsigned char MDQRCodeScanerVersionString[];

@class MDQRCodeScaner;
@protocol MDQRCodeScanerDelegate <NSObject>

@optional
- (void)scaner:(MDQRCodeScaner *)scaner didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects;

- (void)scaner:(MDQRCodeScaner *)scaner brightnessValue:(CGFloat)brightnessValue;

@end

@interface MDQRCodeScaner : NSObject

@property (nonatomic, weak) id<MDQRCodeScanerDelegate> delegate;

@property (nonatomic, copy, readonly) AVCaptureSessionPreset sessionPreset;

@property (nonatomic, copy, readonly) NSArray<AVMetadataObjectType> *metadataObjectTypes;

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

- (void)startInView:(UIView *)view;
- (void)startInView:(UIView *)view immediately:(BOOL)immediately;
- (void)pause;
- (void)resume;
- (void)stop;

@end
