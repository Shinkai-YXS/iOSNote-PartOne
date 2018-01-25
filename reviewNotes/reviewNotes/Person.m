//
//  Person.m
//  LearningNotes
//
//  Created by Shinkai on 2018/1/24.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import "Person.h"

@implementation Person


// 告诉系统模型中的哪些属性需要归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject: _name forKey: @"name"];
    [coder encodeInteger: _age forKey: @"age"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _name = [coder decodeObjectForKey:@"name"];
        _age = [coder decodeIntForKey:@"age"];
    }
    return self;
}
@end
