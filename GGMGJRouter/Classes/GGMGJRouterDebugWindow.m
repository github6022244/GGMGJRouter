//
//  GGMGJRouterDebugWindow.m
//  MGJRouter
//
//  路由调试面板实现
//

#import "GGMGJRouterDebugWindow.h"
#import "GGMGJRouter.h"
#import "GGMGJRouterDefine.h"
#import "UIViewController+GGMGJ.h"
#import "GGMGJRouterDebugViewController.h"

@interface GGMGJRouterDebugInfo ()
@property (nonatomic, copy, readwrite) NSString *URLPattern;
@property (nonatomic, copy, readwrite) NSArray<NSString *> *parameters;
@property (nonatomic, copy, readwrite) NSDate *registeredTime;
@end

@implementation GGMGJRouterDebugInfo

+ (instancetype)infoWithURLPattern:(NSString *)URLPattern
                        parameters:(NSArray<NSString *> *)parameters
                      registeredAt:(NSDate *)time {
    GGMGJRouterDebugInfo *info = [[self alloc] init];
    info->_URLPattern = [URLPattern copy];
    info->_parameters = [parameters copy];
    info->_registeredTime = time;
    return info;
}

@end

@interface GGMGJRouterDebugWindow ()
@property (nonatomic, strong) NSMutableArray<GGMGJRouterDebugInfo *> *routes;
@property (nonatomic, weak) UIViewController *presentingDebugNav;
//@property (nonatomic, assign, getter=isAnimating) BOOL animating;
@end

@implementation GGMGJRouterDebugWindow

+ (instancetype)sharedInstance {
    static GGMGJRouterDebugWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

+ (void)show {
//    [self sharedInstance].animating = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topViewController = [UIViewController gg_getKeyWindowTopViewController];
        if (!topViewController) {
            NSLog(@"[DebugView] Error: keyWindow is nil");
            return;
        }
        
        NSLog(@"[DebugView] >>>>> SHOWING VIEW <<<<<");
        
        GGMGJRouterDebugViewController *debugVC = [GGMGJRouterDebugViewController new];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:debugVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self sharedInstance].presentingDebugNav = debugVC;
        
        [topViewController presentViewController:nav animated:YES completion:^{
//            [self sharedInstance].animating = NO;
        }];
    });
}

+ (void)hide {
//    [self sharedInstance].animating = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance].presentingDebugNav dismissViewControllerAnimated:NO completion:^{
            [self sharedInstance].presentingDebugNav = nil;
//            [self sharedInstance].animating = NO;
        }];
    });
}

+ (void)registerDebugInfo:(GGMGJRouterDebugInfo *)info {
    [[self sharedInstance].routes addObject:info];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    GGMGJRouterDebugInfo *info = [self findRouteWithExactPattern:URLPattern];
    
    [[self sharedInstance].routes removeObject:info];
}

+ (NSArray<GGMGJRouterDebugInfo *> *)allRegisteredRoutes {
    return [[self sharedInstance].routes copy];
}

+ (void)clearAllDebugInfo {
    [[self sharedInstance].routes removeAllObjects];
}

+ (void)exportRoutesToPasteboard {
    NSMutableString *exportString = [NSMutableString string];
    [exportString appendString:@"=== 路由表 ===\n\n"];
    
    for (GGMGJRouterDebugInfo *info in [self allRegisteredRoutes]) {
        [exportString appendFormat:@"%@\n", info.URLPattern];
        if (info.parameters.count > 0) {
            [exportString appendFormat:@"  参数： %@\n", [info.parameters componentsJoinedByString:@", "]];
        }
        [exportString appendFormat:@"  注册时间： %@\n\n", [info.registeredTime description]];
    }
    
    [[UIPasteboard generalPasteboard] setString:exportString];
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- 查询
+ (GGMGJRouterDebugInfo * _Nullable)findRouteWithExactPattern:(NSString *)pattern {
    if (![self sharedInstance].routes.count) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"URLPattern == %@", pattern];
    NSArray *results = [[self sharedInstance].routes filteredArrayUsingPredicate:predicate];
    
    return results.firstObject;
}

@end
