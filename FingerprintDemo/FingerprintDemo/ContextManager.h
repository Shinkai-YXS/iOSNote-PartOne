//
//  ContextManager.h
//  FingerprintDemo
//
//  Created by Shinkai on 2018/1/29.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContextManager : NSObject
// 成功之后 block
@property (nonatomic, copy) void(^successBlock)();
// 失败 Block
@property (nonatomic, copy) void(^codeNegativeTwoBlock)();

+ (instancetype)sharedManager;

- (void)fingerprintIdentification;

@end
