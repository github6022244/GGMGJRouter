//
//  GGMGJRouter.m
//  MGJRouter
//
//  路由统一封装实现
//

#import "GGMGJRouter.h"
#import "MGJRouter+GG.h"

@implementation GGMGJRouter

#pragma mark --- 配置
/// 在接收消息时是否使用userInfo里的参数拼接到url参数，默认NO
+ (void)configMGJParamUseUserInfoAsURLParam:(BOOL)use {
    MGJRouterParam.useUserInfoAsParam = use;
}

#pragma mark - 注册路由

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(GGMGJRouterHandler)handler {
    [self registerURLPattern:URLPattern toHandler:handler parametersDesc:nil];
}

+ (void)registerURLPattern:(NSString *)URLPattern
                 toHandler:(GGMGJRouterHandler)handler
              parametersDesc:(nullable NSArray<NSString *> *)paramsDesc {
    [MGJRouter gg_registerURLPattern:URLPattern toHandler:handler];
//    [MGJRouter registerURLPattern:URLPattern toHandler:handler];
    
    // DEBUG 模式下自动注册调试信息
    #ifdef DEBUG
    GGMGJRouterDebugInfo *info = [GGMGJRouterDebugInfo infoWithURLPattern:URLPattern
                                                               parameters:paramsDesc
                                                             registeredAt:[NSDate date]];
    [GGMGJRouterDebugWindow registerDebugInfo:info];
    #endif
}

+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(GGMGJRouterObjectHandler)handler {
    [self registerURLPattern:URLPattern toObjectHandler:handler parametersDesc:nil];
}

+ (void)registerURLPattern:(NSString *)URLPattern
            toObjectHandler:(GGMGJRouterObjectHandler)handler
               parametersDesc:(nullable NSArray<NSString *> *)paramsDesc {
    [MGJRouter gg_registerURLPattern:URLPattern toObjectHandler:handler];
//    [MGJRouter registerURLPattern:URLPattern toObjectHandler:handler];
    
    #ifdef DEBUG
    if (paramsDesc) {
        GGMGJRouterDebugInfo *info = [GGMGJRouterDebugInfo infoWithURLPattern:URLPattern
                                                                   parameters:paramsDesc
                                                                 registeredAt:[NSDate date]];
        [GGMGJRouterDebugWindow registerDebugInfo:info];
    }
    #endif
}

#pragma mark - 打开路由

/// 打开 URL（支持拦截器）
+ (void)openURL:(NSString *)URL {
    [self openURL:URL completion:nil];
}

/// 打开 URL 带完成回调
+ (void)openURL:(NSString *)URL completion:(GGMGJRouterCompletion)completion {
    [self openURL:URL withUserInfo:nil completion:completion];
}

+ (void)openURL:(NSString *)URL
   withUserInfo:(NSDictionary * _Nullable)userInfo
     completion:(GGMGJRouterCompletion)completion {
    
    // 创建上下文
    GGMGJRouterContext *context = [GGMGJRouterContext contextWithURL:URL userInfo:userInfo];
    
    // 执行拦截器链
    if (![GGMGJRouterInterceptor executeInterceptorsWithContext:context]) {
        return;
    }
    
    // 打开 URL
//    MGJRouterParam *param = nil;
//    
//    if (userInfo) {
//        param = [MGJRouterParam objectWithData:userInfo url:URL];
//    } else {
//        param = [MGJRouterParam objectWithURL:URL];
//    }
    
//    [MGJRouter gg_openURL:URL withParam:param completion:completion];
    [MGJRouter gg_openURL:URL withUserInfo:userInfo completion:completion];
}

+ (void)openRequest:(GGMGJRouterRequest *)request
         completion:(GGMGJRouterCompletion)completion {
    NSString *URL = [request originalURL];
    
    NSDictionary *parameters = [request parametersKeyValue];
    
    [self openURL:URL withUserInfo:parameters completion:completion];
}

#pragma mark - 查询路由

+ (id)objectForURL:(NSString *)URL {
    return [self objectForURL:URL withUserInfo:nil];
}

+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)userInfo {
    return [MGJRouter gg_objectForURL:URL withUserInfo:userInfo];
//    return [MGJRouter gg_objectForURL:URL withUserInfo:userInfo];
}

+ (BOOL)canOpenURL:(NSString *)URL {
    return [MGJRouter canOpenURL:URL];
}

#pragma mark - 拦截器

+ (void)addGlobalInterceptor:(GGMGJInterceptorBlock)block {
    [GGMGJRouterInterceptor addGlobalInterceptor:block];
}

+ (void)addInterceptorForPattern:(NSString *)pattern interceptor:(GGMGJInterceptorBlock)block {
    [GGMGJRouterInterceptor addInterceptorForPattern:pattern interceptor:block];
}

#pragma mark - 生命周期绑定
+ (GGMGLifecycleTaskWrapper *)bindTask:(GGMGJLifecycleTask)task toObject:(id)object withIdentifier:(NSString *)identifier {
    return [GGMGJComponentLifecycle bindTask:task toObject:object identifier:identifier];
}

/// 执行
+ (BOOL)executePendingTasksWithIdentifier:(nonnull id)identifier {
    return [GGMGJComponentLifecycle executePendingTasksWithIdentifier:identifier];
}

#pragma mark - 调试功能

+ (void)showDebugWindow {
    [GGMGJRouterDebugWindow show];
}

+ (void)hideDebugWindow {
    [GGMGJRouterDebugWindow hide];
}

+ (void)exportRoutes {
    [GGMGJRouterDebugWindow exportRoutesToPasteboard];
}

#pragma mark - 工具方法

+ (NSString *)generateURLWithScheme:(NSString *)scheme
                               host:(NSString *)host
                               path:(NSString *)path
                             queries:(nullable NSDictionary<NSString *, NSString *> *)queries {
    // 创建强类型请求
    GGMGJRouterRequest *request = [[GGMGJRouterRequest alloc]
                                   initWithScheme:scheme
                                   host:host
                                   path:path];
    
    // 流式添加参数
    if (queries) {
        request = request.appendQueries(queries);
    }
    
    return [request buildURL];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    [GGMGJRouterDebugWindow deregisterURLPattern:URLPattern];
    
    [GGMGJRouterInterceptor removeInterceptorsWithURL:URLPattern];
    
    [MGJRouter deregisterURLPattern:URLPattern];
}

@end
