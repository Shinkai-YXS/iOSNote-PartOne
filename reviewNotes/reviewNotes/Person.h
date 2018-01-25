//
//  Person.h
//  LearningNotes
//
//  Created by Shinkai on 2018/1/24.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic, assign) int        age;
@property (nonatomic, strong) NSString * name;

@end
