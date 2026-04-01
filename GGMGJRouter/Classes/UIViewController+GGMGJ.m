//
//  UIViewController+GGMGJ.m
//  GGMGJRouter
//
//  Created by GG on 2026/3/31.
//

#import "UIViewController+GGMGJ.h"

#import "UIWindow+GGMGJ.h"

@implementation UIViewController (GGMGJ)

- (UIViewController *)gg_getTopViewController {
    if (self.presentedViewController) {
        return [self.presentedViewController gg_getTopViewController];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController gg_getTopViewController];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController gg_getTopViewController];
    }
    
    return self;
}

+ (UIViewController *)gg_getKeyWindowTopViewController {
    UIWindow *keyWindow = [UIWindow gg_getKeyWindow];
    
    return [keyWindow.rootViewController gg_getTopViewController];
}

@end
