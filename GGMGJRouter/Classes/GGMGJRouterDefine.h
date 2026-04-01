//
//  GGMGJRouterDefine.h
//  GGCommenAppFundation
//
//  Created by GG on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@class MGJRouterParam;

/**
 *  routerParameters 里内置的几个参数会用到上面定义的 string
 */
typedef void (^GGMGJRouterHandler)(NSDictionary * _Nullable routerParameters, MGJRouterParam *_Nullable param);

/**
 *  需要返回一个 object，配合 objectForURL: 使用
 */
typedef id _Nullable (^GGMGJRouterObjectHandler)(NSDictionary * _Nullable routerParameters, MGJRouterParam * _Nullable param);

// openURL completion
typedef void (^GGMGJRouterCompletion)(id _Nullable data);

/// 交换同一个 class 里的 originSelector 和 newSelector 的实现，如果原本不存在 originSelector，则相当于给 class 新增一个叫做 originSelector 的方法
CG_INLINE BOOL
GGMGJExchangeImplementations(Class _class, SEL _originSelector, SEL _newSelector) {
    Method originMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    
    // 尝试将 originSelector 添加为 newSelector 的实现
    BOOL didAddMethod = class_addMethod(_class,
                                        _originSelector,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        // 如果添加成功，说明原本不存在 originSelector
        // 此时需要将 newSelector 替换为 originMethod 的实现（如果 originMethod 存在）
        class_replaceMethod(_class,
                            _newSelector,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        // 如果 originSelector 已存在，则直接交换两个方法的实现
        method_exchangeImplementations(originMethod, newMethod);
    }
    
    return YES;
}
