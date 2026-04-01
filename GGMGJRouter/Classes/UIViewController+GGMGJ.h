//
//  UIViewController+GGMGJ.h
//  GGMGJRouter
//
//  Created by GG on 2026/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GGMGJ)

- (UIViewController *)gg_getTopViewController;

+ (UIViewController *)gg_getKeyWindowTopViewController;

@end

NS_ASSUME_NONNULL_END
