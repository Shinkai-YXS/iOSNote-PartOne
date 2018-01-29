//
//  ContextManager.m
//  FingerprintDemo
//
//  Created by Shinkai on 2018/1/29.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import "ContextManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ContextManager()

@property (nonatomic, strong) LAContext * context;



@end

@implementation ContextManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedManager {
    static ContextManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ContextManager alloc] init];
    });
    return sharedManager;
}

#pragma mark ---- openFunc
- (void) fingerprintIdentification {
    // 判断 iOS8 及以后的版本
    if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
        return;
    }
    
    /**
     判断能否使用指纹识别
     Evaluate: 评估
     Policy: 策略
     LAPolicyDeviceOwnerAuthenticationWithBiometrics: 设备拥有者授权 用 生物识别技术
     */
    if (![self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        NSLog(@"请确保(5S以上机型),TouchID未打开");
        return;
    }
    // localizedReason 本地 alert 提示语
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请允许设备指纹识别" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"指纹验证成功");
            return;
        }
        
        if (error.code != -2) {
            //  指纹识别Touch ID提供3+2 = 5次指纹识别机会----->3次识别失败后，指纹验证框消失(会报错code = -1)然后点击指纹会再次弹框可验证两次，如果五次指纹识别全部错误，就需要手动输入数字密码，数字密码可以输入6次，如果6次输入密码错误，系统停止验证，等待验证时间后会提供再次验证的机会,正确及验证成功(1次),错误则时间累加等待验证,以此类推. (iOS10不一样, 5次之后有问题: 需要进入设置中 -- TouchID与密码, 输入一次密码, 就可以解开)
            //Code=-2 "Canceled by user"(用户取消)
            //Code=-3 "Fallback authentication mechanism selected."(用户在弹出的指纹验证框中，点击输入密码)
            //Code=-7 "No fingers are enrolled with Touch ID."(设备没有设置指纹报错)
            //Code=-1 "Application retry limit exceeded."(用户取消)
            //Code=-8 "Biometry is locked out."(指纹次数上限，锁定手机)
            //有的情况, 需要对错误的次数做累计, 此时就需要排除用户取消
            NSLog(@"指纹失败");
            if (error.code == -8) {
                NSLog(@"指纹次数上限，锁定手机");
            }
        }
    }];
}

#pragma mark ---- getter

- (LAContext *)context {
    if (_context) {
        return _context;
    }
    _context = [[LAContext alloc] init];
    return _context;
}

@end
