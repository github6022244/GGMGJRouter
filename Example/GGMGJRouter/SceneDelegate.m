// SceneDelegate.m
#import "SceneDelegate.h"
#import "GGViewController.h"
#import <GGMGJRouter+GGModuleInitializer.h>

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        GGViewController *vc = [[GGViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    // 启动注册在sceneconnect的模块
    [GGMGJRouter activateModulesForStage:GGModuleInitializerStageSceneWillConnectToSession];
}

@end
