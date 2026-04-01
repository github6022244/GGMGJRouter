//
//  GGMGJDebugViewController.m
//  调试面板示例实现
//

#import "GGMGJDebugViewController.h"
#import <GGMGJRouter.h>

@implementation GGMGJDebugViewController

- (void)dealloc {
    [self deRegist];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调试窗口测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 注册一些路由用于测试
    [self registerTestRoutes];
    [self setupUI];
}

- (void)registerTestRoutes {
    // 注册多个路由用于演示
    [GGMGJRouter registerURLPattern:@"mgj://home" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"首页");
    } parametersDesc:nil];
    
    [GGMGJRouter registerURLPattern:@"mgj://user/:id/:name" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"用户页：%@", params);
    } parametersDesc:@[@"id", @"name"]];
    
    [GGMGJRouter registerURLPattern:@"mgj://product/:category/:itemId/:source" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"商品页：%@", params);
    } parametersDesc:@[@"category", @"itemId", @"source"]];
    
    [GGMGJRouter registerURLPattern:@"mgj://settings/:userId/:name" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"设置页: %@ \nMGJParam: %@", params, param);
    } parametersDesc:@[@"userId", @"name"]];
    
    [GGMGJRouter registerURLPattern:@"test://demo" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"Demo");
    } parametersDesc:nil];
    
    [GGMGJRouter registerURLPattern:@"test://page/:index" toHandler:^(NSDictionary *params, MGJRouterParam *param) {
        NSLog(@"Page: %@", params);
    } parametersDesc:@[@"index"]];
    
    NSLog(@"[DebugVC] Registered %lu routes", (unsigned long)[GGMGJRouterDebugWindow allRegisteredRoutes].count);

}

- (void)deRegist {
    NSArray *urlArr = @[
        @"mgj://home",
        @"mgj://user/:id/:name",
        @"mgj://product/:category/:itemId/:source",
        @"mgj://settings/:userId/:name",
        @"test://demo",
        @"test://page/:index",
    ];
    
    for (NSString *url in urlArr) {
        [GGMGJRouter deregisterURLPattern:url];
    }
}

- (void)setupUI {
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds) - 40, 60)];
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"点击下方按钮显示调试窗口\n窗口会覆盖整个屏幕";
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:tipLabel];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showButton.frame = CGRectMake(50, 200, CGRectGetWidth(self.view.bounds) - 100, 60);
    [showButton setTitle:@"🔍 显示调试窗口" forState:UIControlStateNormal];
    showButton.backgroundColor = [UIColor blueColor];
    [showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showButton.layer.cornerRadius = 10;
    [showButton addTarget:self action:@selector(showButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    hideButton.frame = CGRectMake(50, 280, CGRectGetWidth(self.view.bounds) - 100, 60);
    [hideButton setTitle:@"❌ 隐藏调试窗口" forState:UIControlStateNormal];
    hideButton.backgroundColor = [UIColor redColor];
    [hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hideButton.layer.cornerRadius = 10;
    [hideButton addTarget:self action:@selector(hideButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideButton];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    checkButton.frame = CGRectMake(50, 360, CGRectGetWidth(self.view.bounds) - 100, 60);
    [checkButton setTitle:@"📋 检查路由列表" forState:UIControlStateNormal];
    checkButton.backgroundColor = [UIColor greenColor];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkButton.layer.cornerRadius = 10;
    [checkButton addTarget:self action:@selector(checkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkButton];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 450, CGRectGetWidth(self.view.bounds) - 40, 40)];
    countLabel.tag = 999;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:countLabel];
}

- (void)showButtonTapped {
    NSLog(@"[Test] 点击显示调试窗口");
    [GGMGJRouter showDebugWindow];
}



- (void)hideButtonTapped {
    NSLog(@"[Test] 点击隐藏调试窗口");
    [GGMGJRouter hideDebugWindow];
}

- (void)checkButtonTapped {
    NSArray *routes = [GGMGJRouterDebugWindow allRegisteredRoutes];
    UILabel *countLabel = (UILabel *)[self.view viewWithTag:999];
    countLabel.text = [NSString stringWithFormat:@"已注册路由数：%lu", (unsigned long)routes.count];
    
    NSLog(@"[Test] 已注册的路由:");
    for (GGMGJRouterDebugInfo *info in routes) {
        NSLog(@"  - %@", info.URLPattern);
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"路由列表"
                                                                   message:[NSString stringWithFormat:@"已注册 %lu 个路由", (unsigned long)routes.count]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
