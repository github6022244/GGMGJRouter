//
//  GGSearchModuleManager.m
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import "GGSearchModuleManager.h"

#import "GGRecommendSearchWordsManager.h"

#import <GGMGJRouter+GGModuleInitializer.h>
#import <MGJRouter+GG.h>

@implementation GGSearchModuleManager

static BOOL _moduleDidInit = NO;

#pragma mark ------------------------- Cycle -------------------------
+ (void)load {
    // 初始化
    // 这里首屏渲染后初始化，优先级低
    [GGMGJRouter registerURLPattern:@"search://init" moduleInitializerStage:GGModuleInitializerStageFirstScreenReady priority:800 checkNeedInitBlock:^BOOL{
        return !self.moduleDidInit;
    } initBlock:^{
        // 推荐搜索词初始化
        [self initRecommendSearchWordsManagerManager];
        
        self.moduleDidInit = YES;
    }];
    
    // 获取推荐搜索词数组
    [MGJRouter gg_registerURLPattern:@"search://recommend/words" toObjectHandler:^id _Nullable(NSDictionary * _Nullable routerParameters, MGJRouterParam * _Nullable param) {
        return [GGRecommendSearchWordsManager sharedManager].recommendSearchWords;
    }];
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- 推荐初始化
+ (void)initRecommendSearchWordsManagerManager {
    [[GGRecommendSearchWordsManager sharedManager] loadCacheRecommendSearchWords];
    
    NSLog(@"模块--搜索-推荐搜索词初始化");
}

#pragma mark ------------------------- set / get -------------------------
+ (BOOL)moduleDidInit {
    return _moduleDidInit;
}

+ (void)setModuleDidInit:(BOOL)moduleDidInit {
    _moduleDidInit = moduleDidInit;
}

@end
