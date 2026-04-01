//
//  GGMGJRouter.h
//  MGJRouter
//
//  路由统一封装接口
//

#import <Foundation/Foundation.h>

// 导入所有组件
#import "MGJRouter.h"
#import "MGJRouterParam.h"
#import "GGMGJRouterRequest.h"
#import "GGMGJRouterInterceptor.h"
#import "GGMGJComponentLifecycle.h"
#import "GGMGJRouterDebugWindow.h"

#import "GGMGJRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 统一的 Router 封装类
@interface GGMGJRouter : NSObject

#pragma mark --- 配置
/// 在接收消息时是否使用userInfo里的参数拼接到url参数，默认NO
+ (void)configMGJParamUseUserInfoAsURLParam:(BOOL)use;

#pragma mark - 注册路由

+ (void)registerURLPattern:(NSString *)URLPattern
                 toHandler:(GGMGJRouterHandler)handler;

/// 注册 URL Pattern 到 Handler
/// @param URLPattern URL 模式，如 mgj://beauty/:id
/// @param handler 处理回调
/// @param paramsDesc 参数描述（用于调试），如 @[@"id", @"type"]
+ (void)registerURLPattern:(NSString *)URLPattern
                 toHandler:(GGMGJRouterHandler)handler
              parametersDesc:(nullable NSArray<NSString *> *)paramsDesc;

/// 注册 URL Pattern 到 ObjectHandler
+ (void)registerURLPattern:(NSString *)URLPattern
           toObjectHandler:(GGMGJRouterObjectHandler)handler;
+ (void)registerURLPattern:(NSString *)URLPattern
            toObjectHandler:(GGMGJRouterObjectHandler)handler
               parametersDesc:(nullable NSArray<NSString *> *)paramsDesc;

#pragma mark - 打开路由

/// 打开 URL（支持拦截器）
+ (void)openURL:(NSString *)URL;

/// 打开 URL 带完成回调
+ (void)openURL:(NSString *)URL completion:(GGMGJRouterCompletion _Nullable)completion;

/// 打开 URL 带附加信息和完成回调
+ (void)openURL:(NSString *)URL
   withUserInfo:(NSDictionary * _Nullable)userInfo
     completion:(GGMGJRouterCompletion _Nullable)completion;

/// 使用 Request 对象打开路由
+ (void)openRequest:(GGMGJRouterRequest *)request
         completion:(GGMGJRouterCompletion _Nullable)completion;

#pragma mark - 查询路由

/// 获取 URL 对应的对象
+ (id)objectForURL:(NSString *)URL;

/// 获取 URL 对应的对象（带附加信息）
+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)userInfo;

/// 判断是否可以打开 URL
+ (BOOL)canOpenURL:(NSString *)URL;

#pragma mark - 拦截器

/// 添加全局拦截器
+ (void)addGlobalInterceptor:(GGMGJInterceptorBlock)block;

/// 添加针对特定 Pattern 的拦截器
+ (void)addInterceptorForPattern:(NSString *)pattern interceptor:(GGMGJInterceptorBlock)block;

#pragma mark - 生命周期绑定

/// 绑定任务到 VC 生命周期
/// @param object 内部weak引用
+ (GGMGLifecycleTaskWrapper *)bindTask:(GGMGJLifecycleTask)task toObject:(nonnull id)object withIdentifier:(nonnull NSString *)identifier;

/// 执行
+ (BOOL)executePendingTasksWithIdentifier:(nonnull id)identifier;

#pragma mark - 调试功能

/// 显示调试窗口
+ (void)showDebugWindow;

/// 隐藏调试窗口
+ (void)hideDebugWindow;

/// 导出路由表
+ (void)exportRoutes;

#pragma mark - 工具方法

/// 生成 URL（使用 Builder 模式）
+ (NSString *)generateURLWithScheme:(NSString *)scheme
                               host:(NSString *)host
                               path:(NSString *)path
                             queries:(nullable NSDictionary<NSString *, NSString *> *)queries;

/// 反注册 URL Pattern
+ (void)deregisterURLPattern:(NSString *)URLPattern;

@end

NS_ASSUME_NONNULL_END
