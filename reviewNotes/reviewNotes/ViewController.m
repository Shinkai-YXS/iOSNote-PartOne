//
//  ViewController.m
//  LearningNotes
//
//  Created by Shinkai on 2018/1/22.
//  Copyright © 2018年 Shinkai. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIImage imageTest];
    // NSLog 比较耗资源
    // NSLog(@"%s", __func__);
    
    // 自定义宏打印
    YXSLog(@"%s", __func__);
}

#pragma mark - PlistMemoryNote

// Plist 文件注意点： Plist 文件不能存储自定义对象

- (IBAction)Save:(UIButton *)sender {
    // 谁才能做 Plist —— 数组、字典
    NSArray *array = @[@"123", @"1"];
    /**
      File: 文件的全路径
        先明确文件存储到哪，应用沙盒的某个文件夹中
        获取应用沙盒路径
     */
    // NSString *homePath = NSHomeDirectory();
    // YXSLog(@"%@", homePath);
    
    /**
     获取 Caches 文件夹路径
     directory: 搜索文件夹
     domainMask: 在哪个范围内搜索； NSUserDomainMask - 在用户中查找
     expandTilde: YES - 在路径展开； NO - 不展开沙盒路径
     */
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YXSLog(@"%@", cachesPath);
    // 拼接文件名
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"yxsPlistNote.plist"];
    // 存
    [array writeToFile:filePath atomically:YES];
}

- (IBAction)Read:(UIButton *)sender {
    // 读取：以什么形式就以什么形式读取
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"yxsPlistNote.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    YXSLog(@"%@", array);
}

#pragma mark - 归档存取

- (IBAction)gdSave:(UIButton *)sender {
    // 存储自定义对象使用归档 NSKeyedArchiver
    //[NSKeyedArchiver archiveRootObject:需要归档的对象(任何对象，调用自定义对象的 encodeWithCoder) toFile:存储全路径]
    // 如果一个自定义对象需要归档，必须遵守 NSCoding 协议，并且实现协议的方法。
    
    // 创建自定义对象
    Person *person = [[Person alloc] init];
    person.age = 18;
    person.name = @"yxs";
    
    // 获取 Cache 文件
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachesPath stringByAppendingString:@"yxsGDNote.data"];
    // 归档
    [NSKeyedArchiver archiveRootObject:person toFile:filePath];
}

- (IBAction)gdRead:(UIButton *)sender {
    // 获取 Cache 文件
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachesPath stringByAppendingString:@"yxsGDNote.data"];
    // 解档
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    YXSLog(@"%@ %d", person.name, person.age);
}

@end
