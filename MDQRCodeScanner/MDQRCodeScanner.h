//
//  MDQRCodeScanner.h
//  MDQRCodeScanner
//
//  Created by xulinfeng on 2018/5/11.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//! Project version number for MDQRCodeScanner.
FOUNDATION_EXPORT double MDQRCodeScannerVersionNumber;

//! Project version string for MDQRCodeScanner.
FOUNDATION_EXPORT const unsigned char MDQRCodeScannerVersionString[];

@class MDQRCodeScanner;
@protocol MDQRCodeScannerDelegate <NSObject>

@optional
- (void)scanner:(MDQRCodeScanner *)scanner didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects;

- (void)scanner:(MDQRCodeScanner *)scanner brightnessValue:(CGFloat)brightnessValue;

@end

@interface MDQRCodeScanner : NSObject

@property (nonatomic, weak) id<MDQRCodeScannerDelegate> delegate;

@property (nonatomic, copy, readonly) AVCaptureSessionPreset sessionPreset;
@property (nonatomic, copy, readonly) NSArray<AVMetadataObjectType> *metadataObjectTypes;

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

- (void)startInView:(UIView *)view;
- (void)startInView:(UIView *)view immediately:(BOOL)immediately;
- (void)pause;
- (void)resume;
- (void)stop;

+ (NSString *)stringValueFromQRCodeImage:(UIImage *)QRCodeImage;
+ (UIImage *)QRCodeImageFromString:(NSString *)string;

@end
