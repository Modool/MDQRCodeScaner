//
//  MDQRCodeScaner.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "MDQRCodeScaner.h"

@interface MDQRCodeScaner () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation MDQRCodeScaner

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes; {
    NSCParameterAssert(sessionPreset);
    NSCParameterAssert(metadataObjectTypes);
    if (self = [super init]) {
        _sessionPreset = sessionPreset;
        _metadataObjectTypes = metadataObjectTypes;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    metadataOutput.metadataObjectTypes = _metadataObjectTypes;
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = _sessionPreset;
    
    [_session addOutput:_videoDataOutput];
    [_session addOutput:metadataOutput];
    [_session addInput:deviceInput];
    
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)dealloc{
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (_delegate && [_delegate respondsToSelector:@selector(scaner:didOutputMetadataObjects:)]) {
        [_delegate scaner:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate的方法

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if (_delegate && [_delegate respondsToSelector:@selector(scaner:brightnessValue:)]) {
        [_delegate scaner:self brightnessValue:brightnessValue];
    }
}

- (void)startInView:(UIView *)view{
    [self startInView:view immediately:YES];
}

- (void)startInView:(UIView *)view immediately:(BOOL)immediately; {
    NSCParameterAssert(view);
    
    _videoPreviewLayer.frame = view.bounds;
    [_videoPreviewLayer removeFromSuperlayer];
    [view.layer addSublayer:_videoPreviewLayer];
    
    if (!_session.isRunning && immediately) [_session startRunning];
}

- (void)pause;{
    if (_session.isRunning) [_session stopRunning];
}

- (void)resume;{
    if (!_session.isRunning) [_session startRunning];
}

- (void)stop {
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
}

@end

