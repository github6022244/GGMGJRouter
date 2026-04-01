//
//  MGJRouter+GG.m
//  GGCommenAppFundation
//
//  Created by GG on 2022/6/24.
//

#import "MGJRouter+GG.h"

@implementation MGJRouter (GG)

+ (void)gg_registerURLPattern:(NSString *)URLPattern toHandler:(GGMGJRouterHandler)handler {
    [MGJRouter registerURLPattern:URLPattern toHandler:^(NSDictionary *routerParameters) {
        if (handler) {
            MGJRouterParam *param = [MGJRouterParam objectWithMGJRouterKeyValues:routerParameters];
            
            handler(routerParameters, param);
        }
    }];
}

+ (void)gg_registerURLPattern:(NSString *)URLPattern toObjectHandler:(GGMGJRouterObjectHandler)handler {
    [MGJRouter registerURLPattern:URLPattern toObjectHandler:^id(NSDictionary *routerParameters) {
        if (handler) {
            MGJRouterParam *param = [MGJRouterParam objectWithMGJRouterKeyValues:routerParameters];
            
            return handler(routerParameters, param);
        } else {
            return nil;
        }
    }];
}

+ (void)gg_openURL:(NSString *)URL {
    [self gg_openURL:URL completion:nil];
}

+ (void)gg_openURL:(NSString *)URL completion:(GGMGJRouterCompletion)completion {
    [self gg_openURL:URL withUserInfo:nil completion:completion];
}

+ (void)gg_openURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)param completion:(GGMGJRouterCompletion _Nullable)completion {
//    NSDictionary *dict_param = [param keyValues];
    
    [MGJRouter openURL:URL withUserInfo:param completion:completion];
}

+ (id)gg_objectForURL:(NSString *)URL {
    return [self gg_objectForURL:URL withUserInfo:nil];
}

+ (id)gg_objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo {
//    MGJRouterParam *param = [MGJRouterParam objectWithData:userInfo url:URL];
    
    return [MGJRouter objectForURL:URL withUserInfo:userInfo];
}

@end
