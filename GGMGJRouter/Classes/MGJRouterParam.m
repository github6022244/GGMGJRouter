//
//  MGJRouterParam.m
//  GGCommenAppFundation
//
//  Created by GG on 2022/6/24.
//

#import "MGJRouterParam.h"
#import "MGJRouter.h"

@implementation MGJRouterParam

static BOOL _useUserInfoAsParam = YES;

#pragma mark ------------------------- Interface -------------------------
+ (MGJRouterParam *)objectWithMGJRouterKeyValues:(NSDictionary *)keyValues {
    NSArray *ignoreKeys = @[MGJRouterParameterUserInfo, MGJRouterParameterURL, MGJRouterParameterCompletion];
    
    NSDictionary *dictUserInfo = keyValues[MGJRouterParameterUserInfo];
    NSString *routerURL = keyValues[MGJRouterParameterURL];;
    GGMGJRouterCompletion completionBlock = keyValues[MGJRouterParameterCompletion];
    
    NSMutableDictionary *dictUrlParam = @{}.mutableCopy;
    [keyValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![ignoreKeys containsObject:key]) {
            [dictUrlParam setObject:obj forKey:key];
        }
    }];
    
    MGJRouterParam *param = [self objectWithUrl:routerURL param:dictUrlParam userInfo:dictUserInfo completion:completionBlock];
    
    return param;
}

+ (MGJRouterParam *)objectWithUrl:(NSString * _Nullable)url param:(NSDictionary * _Nullable)param userInfo:(NSDictionary * _Nullable)userInfo completion:(GGMGJRouterCompletion _Nullable)completion {
    MGJRouterParam *obj = [MGJRouterParam new];
    
    NSMutableDictionary *dict_param = [NSMutableDictionary dictionaryWithDictionary:param];
    if (MGJRouterParam.useUserInfoAsParam) {
        // 使用userInfo参数也作为url的传值参数
        [dict_param addEntriesFromDictionary:userInfo];
    }
    
    obj.senderData.data = dict_param;
    obj.senderData.userInfo = userInfo;
    obj.senderData.completion = completion;
    obj.parameterURL = url;
    
    return obj;
}

#pragma mark ------------------------- set / get -------------------------
- (MGJRouterParamSenderData *)senderData {
    if (!_senderData) {
        _senderData = [MGJRouterParamSenderData new];
    }
    
    return _senderData;
}

+ (void)setUseUserInfoAsParam:(BOOL)useUserInfoAsParam {
    _useUserInfoAsParam = useUserInfoAsParam;
}

+ (BOOL)useUserInfoAsParam {
    return _useUserInfoAsParam;
}

@end













@implementation MGJRouterParamSenderData

@end

