//
//  ViewController.m
//  ROYCamera
//
//  Created by Roy on 2016/10/20.
//  Copyright © 2016年 wangruocong. All rights reserved.
//

#import "ViewController.h"

#import <GPUImage.h>
@interface ViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageBilateralFilter *bilateralFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera = videoCamera;
    
    GPUImageView *captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVideoPreview atIndex:0];
    
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
    
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [groupFilter addTarget:bilateralFilter];
    _bilateralFilter = bilateralFilter;
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [groupFilter addTarget:brightnessFilter];
    _brightnessFilter = brightnessFilter;
    
    [bilateralFilter addTarget:brightnessFilter];
    [groupFilter setInitialFilters:@[bilateralFilter]];
    groupFilter.terminalFilter = brightnessFilter;
    
    [videoCamera addTarget:groupFilter];
    [groupFilter addTarget:captureVideoPreview];
    
    [videoCamera startCameraCapture];
}

- (IBAction)brightnessFilter:(UISlider *)sender  {
    
    _brightnessFilter.brightness = sender.value;
    
}
- (IBAction)bilateralFilter:(UISlider *)sender {
    
    CGFloat maxValue = 10;
    [_bilateralFilter setDistanceNormalizationFactor:(maxValue - sender.value)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
