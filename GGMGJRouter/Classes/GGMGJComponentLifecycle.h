//
//  GGMGJComponentLifecycle.h
//  MGJRouter
//
//  组件生命周期绑定助手
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GGMGLifecycleTaskWrapper;

NS_ASSUME_NONNULL_BEGIN

/// 生命周期绑定的任务 Block
typedef void (^GGMGJLifecycleTask)(void);

/// 生命周期管理器
@interface GGMGJComponentLifecycle : NSObject

///// 将任务绑定到 ViewController 的生命周期
///// 当 ViewController 销毁时，未执行的任务会自动失效
//+ (void)bindTask:(GGMGJLifecycleTask)task toViewController:(UIViewController *)viewController;

/// 将任务绑定到任意对象的 dealloc 生命周期
+ (GGMGLifecycleTaskWrapper *)bindTask:(GGMGJLifecycleTask)task toObject:(id)object identifier:(NSString *)identifier;

/// 查询
+ (BOOL)hasValidTasksWithIdentifier:(id)identifier;

/// 执行
+ (BOOL)executePendingTasksWithIdentifier:(nonnull id)identifier;

/// 手动取消任务
+ (void)cancelTaskWithIdentifier:(NSString *)identifier;

/// 清理所有已执行的任务
+ (void)cleanupCompletedTasks;

@end

///// UIViewController 分类，提供便捷方法
//@interface UIViewController (GGMGLifecycle)
//
////@property (nonatomic, copy) void(^ggmgjViewDidDisappearBlock)(void);
//
///// 绑定任务到当前 VC 的生命周期
//- (void)gg_bindToLifecycle:(GGMGJLifecycleTask)task;
//
///// 绑定带标识的任务
//- (void)gg_bindToLifecycle:(GGMGJLifecycleTask)task identifier:(NSString *)identifier;
//
//@end











@interface GGMGLifecycleTaskWrapper : NSObject
@property (nonatomic, copy) GGMGJLifecycleTask task;
@property (nonatomic, assign, getter=isCompleted) BOOL completed;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, weak) id boundObject;

+ (instancetype)wrapperWithTask:(GGMGJLifecycleTask)task
                     identifier:(NSString *)identifier
                     boundObject:(id)object;

- (BOOL)executeTask;
@end

NS_ASSUME_NONNULL_END
