
//
//  GGMGJRouterRequest.h
//  MGJRouter
//
//  强类型路由参数封装
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 路由参数类型定义
typedef NS_ENUM(NSInteger, GGMGJRouterParameterType) {
    GGMGJRouterParameterTypeString,
    GGMGJRouterParameterTypeInt,
    GGMGJRouterParameterTypeFloat,
    GGMGJRouterParameterTypeBool,
    GGMGJRouterParameterTypeObject,
};

/// 参数描述信息
@interface GGMGJRouterParameterDescriptor : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) GGMGJRouterParameterType type;
@property (nonatomic, assign, readonly) BOOL required;
@property (nonatomic, strong, nullable) id defaultValue;

+ (instancetype)descriptorWithName:(NSString *)name
                              type:(GGMGJRouterParameterType)type
                          required:(BOOL)required;

+ (instancetype)descriptorWithName:(NSString *)name
                              type:(GGMGJRouterParameterType)type
                          required:(BOOL)required
                       defaultValue:(nullable id)defaultValue;

@end

/// 强类型路由请求对象
@interface GGMGJRouterRequest : NSObject

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *path;
/// 注意：这里不是真正的 key：value
@property (nonatomic, copy, readonly) NSMutableDictionary<NSString *, GGMGJRouterParameterDescriptor *> *parameters;

/// 初始化路由请求
/// @param scheme scheme 例如 @"mgj"
/// @param host host 例如 @"beauty"
/// @param path path 例如 @"detail"
- (instancetype)initWithScheme:(NSString *)scheme
                          host:(NSString *)host
                          path:(NSString *)path;

- (instancetype)initWithURL:(NSString *)url;

/// 添加参数，默认非必传
- (GGMGJRouterRequest* (^)(NSString *, NSString *))stringParam;
- (GGMGJRouterRequest* (^)(NSString *, id))intParam;
- (GGMGJRouterRequest* (^)(NSString *, id))floatParam;
- (GGMGJRouterRequest* (^)(NSString *, id))boolParam;
- (GGMGJRouterRequest* (^)(NSString *, id))objectParam;
/// 添加参数，可配置是否必传
- (GGMGJRouterRequest* (^)(NSString *, NSString *, BOOL))appendStringParam;
- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendIntParam;
- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendFloatParam;
- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendBoolParam;
- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendObjectParam;
/// 从keyValue格式添加参数，这里必填为NO
- (GGMGJRouterRequest* (^)(NSDictionary<NSString *, id> *))appendQueries;

/// 构建最终的 URL 字符串
- (NSString *)buildURL;

/// 未拼接参数的url
- (NSString *)originalURL;

/// 获取@{参数名：值}字典
- (NSDictionary *)parametersKeyValue;

/// 从字典中获取参数值（带类型检查）
- (nullable id)getValueForKey:(NSString *)key;
- (NSString *)getStringValueForKey:(NSString *)key;
- (NSInteger)getIntValueForKey:(NSString *)key;
- (CGFloat)getFloatValueForKey:(NSString *)key;
- (BOOL)getBoolValueForKey:(NSString *)key;
- (id)objectValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
