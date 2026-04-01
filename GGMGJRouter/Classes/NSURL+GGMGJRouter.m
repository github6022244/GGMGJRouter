//
//  NSURL+GGMGJRouter.m
//  Pods
//
//  Created by GG on 2026/3/30.
//

#import "NSURL+GGMGJRouter.h"

@implementation NSURL (GGMGJRouter)

- (NSDictionary *)getParamsFromURL {
    // 1. 使用 NSURLComponents 解析
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];

    // 2. 获取 queryItems (数组)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in components.queryItems) {
        params[item.name] = item.value;
    }

    return params;
}

@end
