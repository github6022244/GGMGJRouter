//
//  GGRecommendSearchWordsManager.m
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import "GGRecommendSearchWordsManager.h"

#import "GGJSONConvert.h"

@interface GGRecommendSearchWordsManager ()

@property (nonatomic, strong) NSArray<NSString *> *recommendSearchWords;

@end

@implementation GGRecommendSearchWordsManager

#pragma mark ------------------------- Cycle -------------------------
static GGRecommendSearchWordsManager *instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark ------------------------- Private -------------------------
#pragma mark --- 加载本地缓存推荐搜索词
- (void)loadCacheRecommendSearchWords {
    NSDictionary *dict = [GGJSONConvert dictionaryWithJSONFileName:@"GGRecommendSearchWordsJSON"];
    
    self.recommendSearchWords = dict[@"data"];
    
    NSLog(@"推荐词加载本地缓存成功: %@", self.recommendSearchWords);
}

@end
