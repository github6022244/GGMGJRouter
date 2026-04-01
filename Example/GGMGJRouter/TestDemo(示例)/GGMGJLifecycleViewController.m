//
//  GGMGJLifecycleViewController.m
//  生命周期管理示例实现
//

#import "GGMGJLifecycleViewController.h"
#import "GGMGJRouter.h"

@interface GGMGJLifecycleViewController ()

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GGMGJLifecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生命周期管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(50, 100, CGRectGetWidth(self.view.bounds) - 100, 50);
    [button1 setTitle:@"异步回调绑定生命周期" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 8;
    [button1 addTarget:self action:@selector(asyncTaskWithLifecycle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(50, 170, CGRectGetWidth(self.view.bounds) - 100, 50);
    [button2 setTitle:@"模拟页面销毁" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor blueColor];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 8;
    [button2 addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, CGRectGetWidth(self.view.bounds) - 100, 200)];
    _resultLabel.numberOfLines = 0;
    _resultLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_resultLabel];
}

- (void)asyncTaskWithLifecycle {
    __weak typeof(self) wkSelf = self;
    // 使用生命周期绑定，防止页面销毁后执行回调
    [GGMGJRouter bindTask:^{
        // 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"数据加载成功 wkSelf: %@", wkSelf);
            wkSelf.resultLabel.text = @"✅ 数据加载成功！\n页面未销毁，正常更新 UI";
            wkSelf.resultLabel.textColor = [UIColor greenColor];
        });
    } toObject:self withIdentifier:@"test"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        wkSelf.resultLabel.text = @"正在网络请求...";
//        
//        // 网络请求成功后回调block，此时self也许已经释放，任务block已经被移除
//        [GGMGJRouter executePendingTasksWithIdentifier:@"test"];
//    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"[生命周期] 页面已消失");
}

- (void)dealloc {
    NSLog(@"[生命周期] 页面已销毁");
}

- (void)dismissSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
