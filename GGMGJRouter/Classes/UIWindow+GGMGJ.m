//
//  UIWindow+GGMGJ.m
//  GGMGJRouter
//
//  Created by GG on 2026/3/31.
//

#import "UIWindow+GGMGJ.h"

@implementation UIWindow (GGMGJ)

+ (UIWindow *)gg_getKeyWindow {
    UIWindow *result = nil;
    
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        result = window;
                        break;
                    }
                }
                if (result) break;
            }
        }
        if (!result) {
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (window.windowLevel == UIWindowLevelNormal) {
                            result = window;
                            break;
                        }
                    }
                    if (result) break;
                }
            }
        }
    } else {
        result = [UIApplication sharedApplication].keyWindow;
    }
    
    return result;
}

@end
