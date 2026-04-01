//
//  MGJRouterParam.h
//  GGCommenAppFundation
//
//  Created by GG on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGMGJRouterDefine.h"

@class MGJRouterParamSenderData;

NS_ASSUME_NONNULL_BEGIN

@interface MGJRouterParam : NSObject

/// 在接收消息时是否使用userInfo里的参数拼接到url参数，默认YES
@property (class, nonatomic, assign) BOOL useUserInfoAsParam;

@property (nonatomic, copy) NSString *parameterURL;// url

@property (nonatomic, strong) MGJRouterParamSenderData *senderData;// 需向下传递的参数

/// 根据MGJRouter的传值字典创建model
+ (MGJRouterParam *)objectWithMGJRouterKeyValues:(NSDictionary *)keyValues;

@end

NS_ASSUME_NONNULL_END








@interface MGJRouterParamSenderData : NSObject

@property (nonatomic, strong) NSDictionary * _Nullable data;// 自定义参数

@property (nonatomic, strong) NSDictionary * _Nullable userInfo;

@property (nonatomic, copy) GGMGJRouterCompletion _Nullable completion;

@end







