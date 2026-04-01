//
//  GGMGJInterceptorViewController.m
//  路由拦截器示例实现
//

#import "GGMGJInterceptorViewController.h"
#import <GGMGJRouter.h>

static BOOL isLogin = NO;

@implementation GGMGJInterceptorViewController

+ (void)load {
    // 注册商品详情页
    [GGMGJRouter registerURLPattern:@"mgj://product" toHandler:^(NSDictionary * _Nullable routerParameters, MGJRouterParam * _Nullable param) {
        NSLog(@"跳转详情页: %@", param);
    } parametersDesc:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拦截器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupInterceptors];
    [self setupUI];
}

- (void)setupInterceptors {
    // 全局登录检查
    [GGMGJRouter addGlobalInterceptor:^BOOL(GGMGJRouterContext *context) {
        NSLog(@"[全局拦截器] 路由跳转登录判断：%@, 是否登录：%@", context.URL, isLogin ? @"YES" : @"NO");
        if ([context.URL containsString:@"mgj://detail"] && !isLogin) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"需要登录"
                                                                           message:@"请先登录后再访问"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                context.result = GGMGJInterceptorResultRedirect;
                context.redirectURL = @"mgj://login";
                [GGMGJRouter openURL:@"mgj://login"];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        } else {
            return YES;
        }
    }];
    
    // 埋点统计
    [GGMGJRouter addGlobalInterceptor:^BOOL(GGMGJRouterContext *context) {
        NSLog(@"[埋点] 路由跳转：%@, 时间：%@", context.URL, [NSDate date]);
        return YES;
    }];
    
    // 特定 Pattern 拦截
    [GGMGJRouter addInterceptorForPattern:@"mgj://product/*" interceptor:^BOOL(GGMGJRouterContext *context) {
        NSLog(@"[商品拦截器] 访问商品页面：%@", context.URL);
        return YES;
    }];
}

- (void)setupUI {
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(50, 100, CGRectGetWidth(self.view.bounds) - 100, 50);
    [loginButton setTitle:@"切换登录状态" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor purpleColor];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 8;
    [loginButton addTarget:self action:@selector(toggleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    detailButton.frame = CGRectMake(50, 170, CGRectGetWidth(self.view.bounds) - 100, 50);
    [detailButton setTitle:@"访问详情页 (需登录)" forState:UIControlStateNormal];
    detailButton.backgroundColor = [UIColor blueColor];
    [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailButton.layer.cornerRadius = 8;
    [detailButton addTarget:self action:@selector(openDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailButton];
    
    UIButton *productButton = [UIButton buttonWithType:UIButtonTypeSystem];
    productButton.frame = CGRectMake(50, 240, CGRectGetWidth(self.view.bounds) - 100, 50);
    [productButton setTitle:@"访问商品页" forState:UIControlStateNormal];
    productButton.backgroundColor = [UIColor greenColor];
    [productButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    productButton.layer.cornerRadius = 8;
    [productButton addTarget:self action:@selector(openProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:productButton];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 320, CGRectGetWidth(self.view.bounds) - 100, 50)];
    statusLabel.tag = 100;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLabel];
    [self _updateLoginStatusLabel];
}

- (void)_updateLoginStatusLabel {
    UILabel *label = (UILabel *)[self.view viewWithTag:100];
    label.text = [NSString stringWithFormat:@"当前状态：%@", isLogin ? @"已登录" : @"未登录"];
}

- (void)toggleLogin {
    isLogin = !isLogin;
    
    [self _updateLoginStatusLabel];
}

- (void)openDetail {
    [GGMGJRouter openURL:@"mgj://detail?id=123" completion:nil];
}

- (void)openProduct {
    [GGMGJRouter openURL:@"mgj://product?id=456" completion:nil];
}

@end
