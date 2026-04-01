//
//  GGMGJComponentLifecycle.m
//  MGJRouter
//
//  组件生命周期绑定助手实现
//

#import "GGMGJComponentLifecycle.h"
#import "GGMGJRouterDefine.h"

// 关联对象 Key
static char kLifecycleTasksKey;
static char kDeallocObserverKey;

@interface GGMGJComponentLifecycle ()
@property (nonatomic, strong) NSMutableArray<GGMGLifecycleTaskWrapper *> *pendingTasks;
@end

@implementation GGMGJComponentLifecycle

+ (instancetype)sharedManager {
    static GGMGJComponentLifecycle *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pendingTasks = [NSMutableArray array];
    }
    return self;
}

//+ (void)bindTask:(GGMGJLifecycleTask)task toViewController:(UIViewController *)viewController {
//    [self bindTask:task toObject:viewController];
//}

+ (GGMGLifecycleTaskWrapper *)bindTask:(GGMGJLifecycleTask)task toObject:(id)object identifier:(NSString *)identifier {
    if (!task || !object || !identifier) return nil;
    
    GGMGJComponentLifecycle *manager = [self sharedManager];
    
    // 创建任务包装器
    GGMGLifecycleTaskWrapper *wrapper = [GGMGLifecycleTaskWrapper wrapperWithTask:task
                                                                       identifier:identifier
                                                                      boundObject:object];
    
    @synchronized (manager.pendingTasks) {
        [manager.pendingTasks addObject:wrapper];
    }
    
//    // 如果对象是 UIViewController，监听 viewDidDisappear
//    if ([object isKindOfClass:[UIViewController class]]) {
//        [self observeViewControllerLifecycle:(UIViewController *)object];
//    } else {
        // 监听任意对象的 dealloc
        [self observeObjectDeallocation:object];
//    }
    
    return wrapper;
}

+ (BOOL)hasValidTasksWithIdentifier:(id)identifier {
    GGMGLifecycleTaskWrapper *wrapper = [self findWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
        return [wrapper.identifier isEqualToString:identifier];
    }];
    
    return wrapper;
}

/// 执行
+ (BOOL)executePendingTasksWithIdentifier:(nonnull id)identifier {
    GGMGLifecycleTaskWrapper *wrapper = [self findWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
        return [wrapper.identifier isEqualToString:identifier];
    }];
    
    return [wrapper executeTask];
}

+ (void)cancelTaskWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    
    [self removeTaskWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
        return [wrapper.identifier isEqualToString:identifier];
    }];
}

+ (void)cleanupCompletedTasks {
    [self removeTaskWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
        return wrapper.isCompleted;
    }];
}

#pragma mark - Private Methods

+ (GGMGLifecycleTaskWrapper *)findWrapperWhereCondition:(BOOL(^)(GGMGLifecycleTaskWrapper *wrapper))conditionBlock {
    GGMGJComponentLifecycle *manager = [self sharedManager];
    NSMutableArray *marr_pendingTasks = [NSMutableArray arrayWithArray:manager.pendingTasks];
    
    GGMGLifecycleTaskWrapper *obj_find = nil;
    
    BOOL find = NO;
    for (GGMGLifecycleTaskWrapper *obj in marr_pendingTasks) {
        if (conditionBlock) {
            find = conditionBlock(obj);
        }
        
        if (find) {
            obj_find = obj;
            break;
        }
    }
    
    return obj_find;
}

+ (void)removeTaskWrapperWhereCondition:(BOOL(^)(GGMGLifecycleTaskWrapper *wrapper))conditionBlock {
    GGMGJComponentLifecycle *manager = [self sharedManager];
    
    @synchronized (manager.pendingTasks) {
        NSMutableArray *marr_pendingTasks = [NSMutableArray arrayWithArray:manager.pendingTasks];
        
        [marr_pendingTasks enumerateObjectsUsingBlock:^(GGMGLifecycleTaskWrapper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL needRemove = NO;
            if (conditionBlock) {
                needRemove = conditionBlock(obj);
            }
            
            if (needRemove) {
                [manager.pendingTasks removeObject:obj];
            }
        }];
    }
}

//+ (void)observeViewControllerLifecycle:(UIViewController *)viewController {
//    __weak typeof(viewController) weakVC = viewController;
//    
//    viewController.ggmgjViewDidDisappearBlock = ^{
//        [self removeTaskWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
//            if (wrapper.boundObject == weakVC) {
//                // ViewController 消失后，标记任务为已完成（不实际执行）
//                wrapper.completed = YES;
//                return YES;
//            }
//            return NO;
//        }];
//    };
//}

+ (void)observeObjectDeallocation:(id)object {
    // 使用 runtime 关联对象来监听 dealloc
    __weak id weakObject = object;
    
    void (^deallocationBlock)(void) = ^{
        [self removeTaskWrapperWhereCondition:^BOOL(GGMGLifecycleTaskWrapper *wrapper) {
            if (wrapper.boundObject == weakObject) {
                wrapper.completed = YES;
                return YES;
            }
            return NO;
        }];
    };
    
    // 存储 deallocation block
    objc_setAssociatedObject(object, &kDeallocObserverKey, deallocationBlock, OBJC_ASSOCIATION_COPY);
}

@end


















//@implementation UIViewController (GGMGLifecycle)
//
//static char kBindedTasksKey;
//
//+ (void)load {
//    GGMGJExchangeImplementations(self, @selector(viewDidDisappear:), @selector(ggmgj_viewDidDisappear:));
//}
//
//- (void)ggmgj_viewDidDisappear:(BOOL)animated {
//    [self ggmgj_viewDidDisappear:animated];
//    
//    if (self.ggmgjViewDidDisappearBlock) {
//        self.ggmgjViewDidDisappearBlock();
//    }
//}
//
//- (void)gg_bindToLifecycle:(GGMGJLifecycleTask)task {
//    [self gg_bindToLifecycle:task identifier:nil];
//}
//
//- (void)gg_bindToLifecycle:(GGMGJLifecycleTask)task identifier:(NSString *)identifier {
//    if (!task) return;
//    
//    // 创建任务包装器
//    GGMGLifecycleTaskWrapper *wrapper = [GGMGLifecycleTaskWrapper wrapperWithTask:task
//                                                                       identifier:identifier
//                                                                      boundObject:self];
//    
//    // 存储到 VC 的关联对象中
//    NSMutableArray *tasks = objc_getAssociatedObject(self, &kBindedTasksKey);
//    if (!tasks) {
//        tasks = [NSMutableArray array];
//        objc_setAssociatedObject(self, &kBindedTasksKey, tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    [tasks addObject:wrapper];
//    
//    // 在 viewWillDisappear 时清理任务
//    __weak typeof(self) weakSelf = self;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 延迟执行，确保任务可以被取消
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            typeof(weakSelf) strongSelf = weakSelf;
//            if (!strongSelf) return;
//            
//            // 可以在这里添加更多的生命周期管理逻辑
//        });
//    });
//}
//
//- (void)setGgmgjViewDidDisappearBlock:(void (^)(void))ggmgjViewDidDisappearBlock {
//    objc_setAssociatedObject(self, @selector(ggmgjViewDidDisappearBlock), ggmgjViewDidDisappearBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (void (^)(void))ggmgjViewDidDisappearBlock {
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//@end







@implementation GGMGLifecycleTaskWrapper

+ (instancetype)wrapperWithTask:(GGMGJLifecycleTask)task
                     identifier:(NSString *)identifier
                     boundObject:(id)object {
    GGMGLifecycleTaskWrapper *wrapper = [[self alloc] init];
    wrapper->_task = [task copy];
    wrapper->_identifier = identifier;
    wrapper->_boundObject = object;
    wrapper->_completed = NO;
    return wrapper;
}

- (BOOL)executeTask {
    BOOL canExec = self.task && !self.completed && self.boundObject;
    if (canExec) {
        self.task();
    }
    
    return canExec;
}

@end
