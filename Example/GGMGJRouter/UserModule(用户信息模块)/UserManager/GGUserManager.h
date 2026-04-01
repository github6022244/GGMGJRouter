//
//  GGUserManager.h
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GGUserManager : NSObject

@property (nonatomic, strong, readonly) GGUserInfoModel *userInfo;

+ (instancetype)sharedManager;

/// 加载缓存用户信息
- (void)loadCacheUserInfo;

@end

NS_ASSUME_NONNULL_END
