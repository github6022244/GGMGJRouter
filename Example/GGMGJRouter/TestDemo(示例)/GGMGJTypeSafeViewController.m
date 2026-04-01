//
//  GGMGJTypeSafeViewController.m
//  强类型参数封装示例实现
//

#import "GGMGJTypeSafeViewController.h"
#import <GGMGJRouter.h>
#import <QMUIKit.h>

@implementation GGMGJTypeSafeViewController

+ (void)load {
    [GGMGJRouter registerURLPattern:@"mgj://user/profile" toHandler:^(NSDictionary * _Nullable routerParameters, MGJRouterParam * _Nullable param) {
        NSDictionary *senderData = param.senderData.data;
        NSString *logStr = [NSString stringWithFormat:@"收到路由：data = %@", senderData];
        
        NSLog(@"%@", logStr);
        
        if (param.senderData.completion) {
            param.senderData.completion(@"get it");
        }
    } parametersDesc:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"强类型参数";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 100, CGRectGetWidth(self.view.bounds) - 100, 50);
    [button setTitle:@"使用 Request 对象打开路由" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.layer.cornerRadius = 8;
    [button addTarget:self action:@selector(openWithRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, CGRectGetWidth(self.view.bounds) - 100, 100)];
    label.numberOfLines = 0;
    label.text = @"优势：\n1. 编译器检查参数\n2. 自动类型转换\n3. 支持参数验证";
    [self.view addSubview:label];
}

- (void)openWithRequest {
    // 创建强类型请求
    GGMGJRouterRequest *request = [[GGMGJRouterRequest alloc]
                                   initWithScheme:@"mgj"
                                   host:@"user"
                                   path:@"profile"];
    
    // 流式添加参数
    request = request.stringParam(@"userId", @"U12345")
                     .stringParam(@"userName", @"John")
                     .intParam(@"age", @25)
                     .boolParam(@"isVIP", @YES)
                     .appendFloatParam(@"score", @(98.5), YES);
    
    NSString *url = [request buildURL];
    NSLog(@"生成的 URL: %@", url);
    
    [GGMGJRouter openRequest:request completion:^(id result) {
        NSLog(@"跳转完成：%@", result);
    }];
}

@end
