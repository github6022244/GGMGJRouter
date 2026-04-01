//
//  GGMGJRouterDebugWindow.h
//  MGJRouter
//
//  路由调试面板
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 路由注册信息
@interface GGMGJRouterDebugInfo : NSObject

@property (nonatomic, copy, readonly) NSString *URLPattern;
@property (nonatomic, copy, readonly) NSArray<NSString *> *parameters;
@property (nonatomic, copy, readonly) NSDate *registeredTime;
@property (nonatomic, copy, readonly) NSString *sourceFile;
@property (nonatomic, assign, readonly) NSUInteger sourceLine;

+ (instancetype)infoWithURLPattern:(NSString *)URLPattern
                        parameters:(NSArray<NSString *> *)parameters
                      registeredAt:(NSDate *)time;

@end

/// 调试窗口管理器
@interface GGMGJRouterDebugWindow : NSObject

/// 显示调试窗口
+ (void)show;

/// 隐藏调试窗口
+ (void)hide;

/// 注册路由信息（供 DEBUG 模式下自动调用）
+ (void)registerDebugInfo:(GGMGJRouterDebugInfo *)info;

+ (void)deregisterURLPattern:(NSString *)URLPattern;

/// 获取所有已注册的路由信息
+ (NSArray<GGMGJRouterDebugInfo *> *)allRegisteredRoutes;

/// 清空调试信息
+ (void)clearAllDebugInfo;

/// 导出路由表到剪贴板
+ (void)exportRoutesToPasteboard;

@end

/// 宏定义：DEBUG 模式下自动注册
#ifdef DEBUG
#define GG_REGISTER_ROUTE_DEBUG(pattern, ...) \
    [GGMGJRouterDebugWindow registerDebugInfo:[GGMGJRouterDebugInfo infoWithURLPattern:pattern \
                                                                           parameters:@[__VA_ARGS__] \
                                                                         registeredAt:[NSDate date]]];
#else
#define GG_REGISTER_ROUTE_DEBUG(pattern, ...)
#endif

NS_ASSUME_NONNULL_END
