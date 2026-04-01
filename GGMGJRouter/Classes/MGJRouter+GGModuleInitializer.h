//
//  MGJRouter+GGModuleInitializer.h
//  CommeniOSAppFundation
//
//  Created by GG on 2026/3/27.
//

#import "MGJRouter.h"

@class MGJRouterModule;

NS_ASSUME_NONNULL_BEGIN

/// module初始化block
typedef void(^MGJModuleInitializationBlock)(void);

/// module自检是否需要初始化block，return 是否需要
typedef BOOL(^MGJModuleCheckNeedInitBlock)(void);

/// module初始化时机定义
typedef NS_ENUM(NSInteger, GGModuleInitializerStage) {
    /// App启动时初始化，对应didFinishLaunchingWithOptions
    GGModuleInitializerStageAppFinishLaunching = 500,
    /// UI准备就绪时初始化，对应SceneDelegate sceneWillConnectToSession
    GGModuleInitializerStageSceneWillConnectToSession = 400,
    /// App首屏渲染完成后初始化
    GGModuleInitializerStageFirstScreenReady = 0,
};

@interface MGJRouter (GGModuleInitializer)

// 注册module初始化，必须在每个module的+load里执行
+ (void)registerURLPattern:(NSString *)URLPattern moduleInitializerStage:(GGModuleInitializerStage)stage priority:(NSInteger)priority checkNeedInitBlock:(MGJModuleCheckNeedInitBlock)checkNeedInitBlock initBlock:(MGJModuleInitializationBlock)initBlock;

// App在不同阶段调用此方法，来激活该阶段的路由，不要在自己module中使用，由主app控制
+ (void)activateModulesForStage:(GGModuleInitializerStage)stage;

@end







@interface MGJRouterModule : NSObject

/// url
@property (nonatomic, copy) NSString *URLPattern;

/// 初始化时机
@property (nonatomic, assign) GGModuleInitializerStage stage;

/// 如果初始化时机相同，二级优先级，数值越大，优先级越高，越早被初始化。
@property (nonatomic, assign) NSInteger priority;

/// module自检是否需要初始化block，return 是否需要
@property (nonatomic, copy) MGJModuleCheckNeedInitBlock checkNeedInitBlock;

/// 初始化block
@property (nonatomic, copy) MGJModuleInitializationBlock initBlock;

- (instancetype)initWithURLPattern:(NSString *)URLPattern stage:(GGModuleInitializerStage)stage priority:(NSInteger)priority checkNeedInitBlock:(MGJModuleCheckNeedInitBlock)checkNeedInitBlock initBlock:(MGJModuleInitializationBlock)initBlock;

/// 检查是否需要初始化
- (BOOL)checkNeedInit;

@end

NS_ASSUME_NONNULL_END
