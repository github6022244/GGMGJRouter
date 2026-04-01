//
//  GGUserModuleManager.m
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import "GGUserModuleManager.h"

#import "GGUserManager.h"
#import "MJExtension.h"

#import "GGMGJRouter+GGModuleInitializer.h"

@implementation GGUserModuleManager

static BOOL _moduleDidInit = NO;

#pragma mark ------------------------- Cycle -------------------------
+ (void)load {
    // 用户模块初始化
    // 这里在app launch后直接初始化，优先级最高
    [GGMGJRouter registerURLPattern:@"user://init" moduleInitializerStage:GGModuleInitializerStageAppFinishLaunching priority:900 checkNeedInitBlock:^BOOL{
        return !self.moduleDidInit;
    } initBlock:^{
        // UserManager初始化
        [self initUserInfoManager];
        
        self.moduleDidInit = YES;
    }];
    
    // 获取用户信息
    [MGJRouter registerURLPattern:@"user://getUserInfo" toObjectHandler:^id(NSDictionary *routerParameters) {
        return [GGUserManager sharedManager].userInfo.mj_keyValues;
    }];
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- GGUserManager初始化
+ (void)initUserInfoManager {
    // 加载本地用户信息
    [[GGUserManager sharedManager] loadCacheUserInfo];
    
    NSLog(@"模块--用户-本地用户信息初始化");
}

#pragma mark ------------------------- set / get -------------------------
+ (BOOL)moduleDidInit {
    return _moduleDidInit;
}

+ (void)setModuleDidInit:(BOOL)moduleDidInit {
    _moduleDidInit = moduleDidInit;
}

@end
