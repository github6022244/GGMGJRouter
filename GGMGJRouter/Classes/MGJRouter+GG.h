//
//  MGJRouter+GG.h
//  GGCommenAppFundation
//
//  Created by GG on 2022/6/24.
//

#import "MGJRouter.h"
#import "MGJRouterGGDefine.h"
#import "MGJRouterParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGJRouter (GG)

// 正常功能
+ (void)gg_registerURLPattern:(NSString *)URLPattern toHandler:(GGMGJRouterHandler)handler;

+ (void)gg_registerURLPattern:(NSString *)URLPattern toObjectHandler:(GGMGJRouterObjectHandler)handler;

+ (void)gg_openURL:(NSString *)URL;

+ (void)gg_openURL:(NSString *)URL completion:(GGMGJRouterCompletion _Nullable)completion;

+ (void)gg_openURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)param completion:(GGMGJRouterCompletion _Nullable)completion;

+ (id)gg_objectForURL:(NSString *)URL;

+ (id)gg_objectForURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)userInfo;

@end

NS_ASSUME_NONNULL_END
