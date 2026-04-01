//
//  GGRecommendSearchWordsManager.h
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGRecommendSearchWordsManager : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *recommendSearchWords;

+ (instancetype)sharedManager;

/// 加载本地缓存推荐搜索词
- (void)loadCacheRecommendSearchWords;

@end

NS_ASSUME_NONNULL_END
