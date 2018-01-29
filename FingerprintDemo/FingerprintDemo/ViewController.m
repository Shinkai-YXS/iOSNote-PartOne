//
//  ViewController.m
//  FingerprintDemo
//
//  Created by Shinkai on 2018/1/26.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import "ViewController.h"
#import "ContextManager.h"

//屏幕  宽
#define Screen_Width [UIScreen mainScreen].bounds.size.width
//屏幕  高
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIButton * button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
}

#pragma mark --- click
- (void) buttonClick {
    [ContextManager.sharedManager fingerprintIdentification];
}

#pragma mark --- getter
- (UIButton *)button {
    if (_button) {
        return _button;
    }
    _button = [[UIButton alloc] init];
    [_button setTitle:@"点击进行指纹识别" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor brownColor];
    _button.layer.cornerRadius = 5;
    _button.clipsToBounds = true;
    _button.frame = CGRectMake(Screen_Width / 2 - 100, Screen_Height / 2 - 22, 200, 44);
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    return _button;
}

@end
