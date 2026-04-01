
//
//  GGMGJRouterRequest.m
//  MGJRouter
//
//  强类型路由参数封装实现
//

#import "GGMGJRouterRequest.h"

#import "NSURL+GGMGJRouter.h"

@implementation GGMGJRouterParameterDescriptor

+ (instancetype)descriptorWithName:(NSString *)name
                              type:(GGMGJRouterParameterType)type
                          required:(BOOL)required {
    return [self descriptorWithName:name type:type required:required defaultValue:nil];
}

+ (instancetype)descriptorWithName:(NSString *)name
                              type:(GGMGJRouterParameterType)type
                          required:(BOOL)required
                       defaultValue:(nullable id)defaultValue {
    GGMGJRouterParameterDescriptor *descriptor = [[self alloc] init];
    if (descriptor) {
        descriptor->_name = name;
        descriptor->_type = type;
        descriptor->_required = required;
        descriptor->_defaultValue = defaultValue;
    }
    return descriptor;
}

@end

@interface GGMGJRouterRequest ()

@property (nonatomic, strong) NSMutableDictionary *paramValues;

@end

@implementation GGMGJRouterRequest

- (instancetype)initWithScheme:(NSString *)scheme
                          host:(NSString *)host
                          path:(NSString *)path {
    self = [super init];
    if (self) {
        _scheme = [scheme copy];
        _host = [host copy];
        _path = [path copy];
        [self configInit];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        NSURL *myUrl = [NSURL URLWithString:url];
        _scheme = myUrl.scheme;
        _host = myUrl.host;
        _path = myUrl.path;
        [self configInit];
        
        NSDictionary *paramDict = [myUrl getParamsFromURL];
        self = self.appendQueries(paramDict);
    }
    
    return self;
}

- (void)configInit {
    _parameters = [NSMutableDictionary dictionary];
    _paramValues = [NSMutableDictionary dictionary];
}

- (GGMGJRouterRequest* (^)(NSString *, NSString *))stringParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, NSString *value) {
        wkSelf.appendStringParam(key, value, NO);
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id))intParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value) {
        wkSelf.appendIntParam(key, value, NO);
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id))floatParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value) {
        wkSelf.appendFloatParam(key, value, NO);
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id))boolParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value) {
        wkSelf.appendBoolParam(key, value, NO);
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id))objectParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value) {
        wkSelf.appendObjectParam(key, value, NO);
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, NSString *, BOOL))appendStringParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, NSString *value, BOOL required) {
        if (required && !value) {
            NSAssert(NO, @"非空错误: %@ 是必填", key);
            return wkSelf;
        }
        
        // 类型校验
        if (![value isKindOfClass:[NSString class]]) {
            NSAssert(NO, @"参数类型错误: %@ 必须是 NSString", key);
            return wkSelf;
        }
        
        // 注册参数描述 (记录 required)
        wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                                 type:GGMGJRouterParameterTypeString
                                                                             required:required];
        // 赋值
        wkSelf.paramValues[key] = value;
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendIntParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value, BOOL required) {
        if (required && !value) {
            NSAssert(NO, @"非空错误: %@ 是必填", key);
            return wkSelf;
        }
        
        // 类型校验 (必须是 NSNumber)
        if (![value isKindOfClass:[NSNumber class]]) {
             NSAssert(NO, @"参数类型错误: %@ 必须是 NSNumber", key);
             return wkSelf;
        }

        wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                                 type:GGMGJRouterParameterTypeInt
                                                                             required:required];
        wkSelf.paramValues[key] = value;
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendBoolParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value, BOOL required) {
        if (required && !value) {
            NSAssert(NO, @"非空错误: %@ 是必填", key);
            return wkSelf;
        }
        
        // 类型校验
        if (![value isKindOfClass:[NSNumber class]]) {
            NSAssert(NO, @"参数类型错误: %@ 必须是 NSNumber", key);
            return wkSelf;
        }

        wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                                 type:GGMGJRouterParameterTypeBool
                                                                             required:required];
        wkSelf.paramValues[key] = value;
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendFloatParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value, BOOL required) {
        if (required && !value) {
            NSAssert(NO, @"非空错误: %@ 是必填", key);
            return wkSelf;
        }
        
        // 类型校验
        if (![value isKindOfClass:[NSNumber class]]) {
            NSAssert(NO, @"参数类型错误: %@ 必须是 NSNumber", key);
            return wkSelf;
        }
        
        wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                         type:GGMGJRouterParameterTypeFloat
                                                                     required:required];
        wkSelf.paramValues[key] = value;
        return wkSelf;
    };
}

- (GGMGJRouterRequest* (^)(NSString *, id, BOOL))appendObjectParam {
    __weak typeof(self) wkSelf = self;
    return ^(NSString *key, id value, BOOL required) {
        if (required && !value) {
            NSAssert(NO, @"非空错误: %@ 是必填", key);
            return wkSelf;
        }
        
        wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                         type:GGMGJRouterParameterTypeObject
                                                                     required:required];
        wkSelf.paramValues[key] = value;
        return wkSelf;
    };
}

/// 从keyValue格式添加参数，这里必填为NO
- (GGMGJRouterRequest* (^)(NSDictionary<NSString *, id> *))appendQueries {
    __weak typeof(self) wkSelf = self;
    return ^(NSDictionary *value) {
        if (!value) {
            return wkSelf;
        }
        
        for (id key in value.allKeys) {
            if (![key isKindOfClass:[NSString class]]) {
                NSAssert(NO, @"key类型错误: %@ 必须是NSString", key);
                return wkSelf;
            }
            
            wkSelf.parameters[key] = [GGMGJRouterParameterDescriptor descriptorWithName:key
                                                                             type:GGMGJRouterParameterTypeObject
                                                                         required:NO];
            wkSelf.paramValues[key] = value[key];
        }

        return wkSelf;
    };
}

- (NSString *)buildURL {
    NSMutableString *url = [self originalURL].mutableCopy;
    
    if (_paramValues.count > 0) {
        [url appendString:@"?"];
        NSMutableArray *queryItems = [NSMutableArray array];
        
        [_paramValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            NSString *value = nil;
            if ([obj isKindOfClass:[NSString class]]) {
                value = obj;
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                value = [obj stringValue];
            } else {
                value = [obj description];
            }
            
            if (value) {
                NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [queryItems addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
            }
        }];
        
        [url appendString:[queryItems componentsJoinedByString:@"&"]];
    }
    
    return url;
}

- (NSString *)originalURL {
    return [NSString stringWithFormat:@"%@://%@/%@", self.scheme, self.host, self.path];
}

/// 获取@{参数名：值}字典
- (NSDictionary *)parametersKeyValue {
    return self.paramValues;
}

- (nullable id)getValueForKey:(NSString *)key {
    return _paramValues[key];
}

- (NSString *)getStringValueForKey:(NSString *)key {
    id value = _paramValues[key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return [value description];
}

- (NSInteger)getIntValueForKey:(NSString *)key {
    id value = _paramValues[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) integerValue];
    }
    return 0;
}

- (CGFloat)getFloatValueForKey:(NSString *)key {
    id value = _paramValues[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) floatValue];
    }
    return 0.0f;
}

- (BOOL)getBoolValueForKey:(NSString *)key {
    id value = _paramValues[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) boolValue];
    }
    return NO;
}

- (id)objectValueForKey:(NSString *)key {
    return _paramValues[key];
}

@end
