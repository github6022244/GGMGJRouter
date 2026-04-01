//
//  GGRouterEventDemoViewController.m
//  GGMGJRouter
//
//  Created by github6022244 on 2026/03/30.
//

#import "GGRouterEventDemoViewController.h"

#import <MGJRouter+GGModuleInitializer.h>
#import <GGMGJRouter.h>

@interface GGRouterEventDemoViewController ()
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation GGRouterEventDemoViewController

+ (void)load {
    // 这里先注册个功能
    [GGMGJRouter registerURLPattern:@"test" toHandler:^(NSDictionary * _Nullable routerParameters, MGJRouterParam * _Nullable param) {
        NSLog(@"[Global Handler] test - userInfo: %@", param.senderData.data);
        
        if (param.senderData.completion) {
            param.senderData.completion(@"get it");
        }
    } parametersDesc:@[
        @"测试",
    ]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actionBtn.frame = CGRectMake(50, 150, self.view.bounds.size.width - 100, 50);
    [actionBtn setTitle:@"点击触发 'test' 路由" forState:UIControlStateNormal];
    actionBtn.backgroundColor = [UIColor systemBlueColor];
    actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    actionBtn.layer.cornerRadius = 10;
    
    [actionBtn addTarget:self action:@selector(didTapTriggerRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionBtn];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, self.view.bounds.size.width - 40, 100)];
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.textColor = [UIColor darkGrayColor];
    self.resultLabel.text = @"等待操作...";
    [self.view addSubview:self.resultLabel];
}

- (void)didTapTriggerRoute {
    self.resultLabel.text = @"正在发送路由请求...";
    
//    // 构造参数
//    MGJRouterParam *param = [MGJRouterParam objectWithData:@{
//        @"data": @"测试数据来自新页面",
//    }];
    
    // 发送请求
    [GGMGJRouter openURL:@"test" withUserInfo:@{
        @"data": @"测试数据来自新页面",
    } completion:^(id  _Nonnull result) {
        // 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = [NSString stringWithFormat:@"收到回调结果:\n%@", result];
        });
    }];
//    [MGJRouter gg_openURL:@"test" withParam:param completion:^(id  _Nullable data) {
//        // 回到主线程更新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.resultLabel.text = [NSString stringWithFormat:@"收到回调结果:\n%@", data];
//        });
//    }];
}

@end
