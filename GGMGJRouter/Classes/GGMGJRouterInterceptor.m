//
//  GGMGJRouterInterceptor.m
//  MGJRouter
//
//  路由拦截器实现
//

#import "GGMGJRouterInterceptor.h"
#import "GGMGJRouter.h"

@interface GGMGJRouterContext ()
@property (nonatomic, copy, readwrite) NSString *URL;
@property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation GGMGJRouterContext

+ (instancetype)contextWithURL:(NSString *)URL userInfo:(nullable NSDictionary *)userInfo {
    GGMGJRouterContext *context = [[self alloc] init];
    context->_URL = [URL copy];
    context->_userInfo = [userInfo copy];
    context->_extraInfo = [NSMutableDictionary dictionary];
    context->_result = GGMGJInterceptorResultPass;
    return context;
}

@end

@interface GGMGJRouterInterceptor ()
@property (nonatomic, strong) NSMutableArray<GGMGJInterceptorBlock> *globalInterceptors;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *patternInterceptors;
@end

@implementation GGMGJRouterInterceptor

+ (instancetype)sharedInstance {
    static GGMGJRouterInterceptor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _globalInterceptors = [NSMutableArray array];
        _patternInterceptors = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)addGlobalInterceptor:(GGMGJInterceptorBlock)block {
    if (block) {
        [[self sharedInstance].globalInterceptors addObject:block];
    }
}

+ (void)removeGlobalInterceptor:(GGMGJInterceptorBlock)block {
    [[self sharedInstance].globalInterceptors removeObject:block];
}

+ (void)removeAllGlobalInterceptors {
    [[self sharedInstance].globalInterceptors removeAllObjects];
}

+ (void)addInterceptorForPattern:(NSString *)pattern interceptor:(GGMGJInterceptorBlock)block {
    if (!pattern || !block) return;
    
    GGMGJRouterInterceptor *manager = [self sharedInstance];
    if (!manager.patternInterceptors[pattern]) {
        manager.patternInterceptors[pattern] = [NSMutableArray array];
    }
    [manager.patternInterceptors[pattern] addObject:block];
}

/// 移除某个拦截器
+ (void)removeInterceptorsWithURL:(NSString *)url {
    if (!url) return;
    
    GGMGJRouterInterceptor *manager = [self sharedInstance];
    
    [manager.patternInterceptors removeObjectForKey:url];
}

+ (BOOL)executeInterceptorsWithContext:(GGMGJRouterContext *)context {
    GGMGJRouterInterceptor *manager = [self sharedInstance];
    
    // 执行全局拦截器
    for (GGMGJInterceptorBlock block in manager.globalInterceptors) {
        if (!block(context)) {
            return NO;
        }
        if (context.result == GGMGJInterceptorResultBlock) {
            return NO;
        }
        if (context.result == GGMGJInterceptorResultRedirect) {
            // 重定向处理
            if (context.redirectURL) {
                [GGMGJRouter openURL:context.redirectURL];
            }
            return NO;
        }
    }
    
    // 执行特定 Pattern 的拦截器
    NSArray *patterns = [manager.patternInterceptors allKeys];
    for (NSString *pattern in patterns) {
        if ([MGJRouter canOpenURL:context.URL matchExactly:NO]) {
            NSArray *interceptors = manager.patternInterceptors[pattern];
            for (GGMGJInterceptorBlock block in interceptors) {
                if (!block(context)) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

+ (NSUInteger)globalInterceptorCount {
    return [[self sharedInstance].globalInterceptors count];
}

@end
