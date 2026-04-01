//
//  GGUserManager.m
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import "GGUserManager.h"

#import <MJExtension.h>
#import "GGJSONConvert.h"

@interface GGUserManager ()

@property (nonatomic, strong) GGUserInfoModel *userInfo;

@end

@implementation GGUserManager

#pragma mark ------------------------- Cycle -------------------------
static GGUserManager *instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- 加载缓存用户信息
- (void)loadCacheUserInfo {
    NSDictionary *dict = [GGJSONConvert dictionaryWithJSONFileName:@"GGUserInfoJSON"];
    
    self.userInfo = [GGUserInfoModel mj_objectWithKeyValues:dict];
    
    NSLog(@"用户信息加载本地缓存成功: %@", dict);
}

@end
