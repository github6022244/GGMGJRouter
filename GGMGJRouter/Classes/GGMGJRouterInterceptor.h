//
//  GGMGJRouterInterceptor.h
//  MGJRouter
//
//  路由拦截器
//

#import <Foundation/Foundation.h>

@class GGMGJRouterContext;

NS_ASSUME_NONNULL_BEGIN

/// 拦截结果
typedef NS_ENUM(NSInteger, GGMGJInterceptorResult) {
    GGMGJInterceptorResultPass,     // 放行
    GGMGJInterceptorResultBlock,    // 阻止
    GGMGJInterceptorResultRedirect, // 重定向
};

/// 路由上下文
@interface GGMGJRouterContext : NSObject

@property (nonatomic, copy, readonly) NSString *URL;
@property (nonatomic, strong, readonly, nullable) NSDictionary *userInfo;
@property (nonatomic, strong, nullable) NSMutableDictionary *extraInfo;
@property (nonatomic, assign) GGMGJInterceptorResult result;
@property (nonatomic, copy, nullable) NSString *redirectURL;

+ (instancetype)contextWithURL:(NSString *)URL userInfo:(nullable NSDictionary *)userInfo;

@end

/// 拦截器 Block
typedef BOOL (^GGMGJInterceptorBlock)(GGMGJRouterContext *context);

/// 全局拦截器管理器
@interface GGMGJRouterInterceptor : NSObject

/// 添加全局拦截器（按添加顺序执行）
+ (void)addGlobalInterceptor:(GGMGJInterceptorBlock)block;

/// 移除全局拦截器
+ (void)removeGlobalInterceptor:(GGMGJInterceptorBlock)block;

/// 清除所有全局拦截器
+ (void)removeAllGlobalInterceptors;

/// 添加针对特定 URL Pattern 的拦截器
+ (void)addInterceptorForPattern:(NSString *)pattern interceptor:(GGMGJInterceptorBlock)block;

/// 执行拦截器链
+ (BOOL)executeInterceptorsWithContext:(GGMGJRouterContext *)context;

/// 移除某个拦截器
+ (void)removeInterceptorsWithURL:(NSString *)url;

/// 获取所有拦截器数量（用于调试）
+ (NSUInteger)globalInterceptorCount;

@end

NS_ASSUME_NONNULL_END
