//
//  MGJRouter+GGModuleInitializer.m
//  CommeniOSAppFundation
//
//  Created by GG on 2026/3/27.
//

#import "MGJRouter+GGModuleInitializer.h"

#import <objc/runtime.h>

/// serial队列
static dispatch_queue_t sActivationQueue = NULL;
/// 保存stage与module数组的字典
static NSMutableDictionary<NSNumber *, NSMutableArray<MGJRouterModule *> *> *sPendingModulesByStage = nil;

@implementation MGJRouter (GGModuleInitializer)

#pragma mark ------------------------- Cycle -------------------------
+ (void)load {
    // 初始化
    [self _initModuleRouter];
}

#pragma mark ------------------------- Interface -------------------------
// 注册module初始化时机
+ (void)registerURLPattern:(NSString *)URLPattern moduleInitializerStage:(GGModuleInitializerStage)stage priority:(NSInteger)priority checkNeedInitBlock:(MGJModuleCheckNeedInitBlock)checkNeedInitBlock initBlock:(MGJModuleInitializationBlock)initBlock {
    if (!URLPattern || !initBlock) {
        [self log:[NSString stringWithFormat:@"模块初始化参数有误，URLPattern: %@，initBlock: %@", URLPattern, initBlock]];
        return;
    }
    
    MGJRouterModule *pendingModule = [[MGJRouterModule alloc] initWithURLPattern:URLPattern stage:stage priority:priority checkNeedInitBlock:checkNeedInitBlock initBlock:initBlock];
    
    // 保存
    [self _saveAModuleRegist:pendingModule];
}

// App在不同阶段调用此方法，来激活该阶段的路由
+ (void)activateModulesForStage:(GGModuleInitializerStage)stage {
    [self syncSerialQueueBlock:^{
        NSMutableArray *stageModulesArray = [self _getModuleArrayForStage:stage];
        
        if (!stageModulesArray || stageModulesArray.count == 0) {
            return;
        }
        
        // 按priority倒序排序
        NSArray *sortedModules = [stageModulesArray sortedArrayUsingComparator:^NSComparisonResult(MGJRouterModule * _Nonnull obj1, MGJRouterModule * _Nonnull obj2) {
            return [@(obj2.priority) compare:@(obj1.priority)];
        }];
        
        // 初始化
        for (MGJRouterModule *module in sortedModules) {
            BOOL needInit = [module checkNeedInit];
            
            if (needInit) {
                if (module.initBlock) {
                    module.initBlock();
                }
            }
        }
        
        // 移除已经初始化的module
        [self _unregisterModuleForStage:stage];
    }];
}

#pragma mark ------------------------- Private -------------------------
/// 初始化
+ (void)_initModuleRouter {
    // 初始化队列
    NSString *queueName = [NSString stringWithFormat:@"com.gg.mgjrouter.initializer.%p", self];
    sActivationQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
    
    // 初始化字典
    sPendingModulesByStage = [[NSMutableDictionary alloc] init];
}

/// 移除某个阶段已注册的全部module
+ (void)_unregisterModuleForStage:(GGModuleInitializerStage)stage {
    [self asyncSerialQueueBlock:^{
        [[self _modulesDict] removeObjectForKey:@(stage)];
    }];
}

/// 保存某个注册的module
+ (void)_saveAModuleRegist:(MGJRouterModule *)pendingModule {
    [self asyncSerialQueueBlock:^{
        NSMutableArray *modules = [self _getModuleArrayForStage:pendingModule.stage];
        
        [modules addObject:pendingModule];
    }];
}

/// 根据stage获取对应的module数组
+ (NSMutableArray<MGJRouterModule *> *)_getModuleArrayForStage:(GGModuleInitializerStage)stage {
    NSNumber *stageKey = @(stage);
    NSMutableArray *modules = [self _modulesDict][stageKey];
    if (!modules) {
        modules = [[NSMutableArray alloc] init];
        [self _modulesDict][stageKey] = modules;
    }
    
    return modules;
}

+ (void)asyncSerialQueueBlock:(void(^)(void))block {
    dispatch_async([self _serialQueue], ^{
        if (block) {
            block();
        }
    });
}

+ (void)syncSerialQueueBlock:(void(^)(void))block {
    dispatch_sync([self _serialQueue], ^{
        if (block) {
            block();
        }
    });
}

/// 类方法获取queue属性
+ (dispatch_queue_t)_serialQueue {
    return sActivationQueue;
}

/// 类方法获取module字典属性
+ (NSMutableDictionary<NSNumber *, NSMutableArray<MGJRouterModule *> *> *)_modulesDict {
    return sPendingModulesByStage;
}

+ (void)log:(NSString *)string {
    NSLog(@"[MGJRouter (GGModuleInitializer)] %@", string);
}

@end














@implementation MGJRouterModule

- (instancetype)initWithURLPattern:(NSString *)URLPattern stage:(GGModuleInitializerStage)stage priority:(NSInteger)priority checkNeedInitBlock:(MGJModuleCheckNeedInitBlock)checkNeedInitBlock initBlock:(MGJModuleInitializationBlock)initBlock {
    if (self = [super init]) {
        _URLPattern = URLPattern;
        _stage = stage;
        _priority = priority;
        _checkNeedInitBlock = checkNeedInitBlock;
        _initBlock = [initBlock copy];
    }
    return self;
}

/// 检查是否需要初始化
- (BOOL)checkNeedInit {
    if (!self.checkNeedInitBlock) {
        return YES;
    }
    
    return self.checkNeedInitBlock();
}

@end
