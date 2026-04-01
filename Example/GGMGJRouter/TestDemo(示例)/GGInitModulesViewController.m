//
//  GGInitModulesViewController.m
//  GGMGJRouter
//
//  Created by github6022244 on 2026/03/30.
//

#import "GGInitModulesViewController.h"
#import <MGJRouter+GGModuleInitializer.h>
#import <GGMGJRouter.h>

@interface GGInitModulesViewController ()

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UILabel *userInfoLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GGInitModulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    // 首屏渲染完成初始化模块 (保持原有逻辑)，正常可以放入window的rootViewController、首页UI渲染完成后调用
    [MGJRouter activateModulesForStage:GGModuleInitializerStageFirstScreenReady];
    
    [self startScrollingWords];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupUI {
    UILabel *desc_1 = [[UILabel alloc] init];
    desc_1.text = @"此页面仅展示App首页渲染完成后初始化的模块，其他初始化时机在Appdelegate、UIScene也有";
    desc_1.textColor = [UIColor grayColor];
    desc_1.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, 60);
    desc_1.numberOfLines = 0;
    [self.view addSubview:desc_1];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width - 40, 44)];
    self.searchTF.textColor = [UIColor blackColor];
    self.searchTF.backgroundColor = [UIColor yellowColor];
    self.searchTF.font = [UIFont systemFontOfSize:16];
    self.searchTF.textAlignment = NSTextAlignmentCenter;
    self.searchTF.layer.cornerRadius = 8;
    self.searchTF.layer.masksToBounds = YES;
    [self.view addSubview:self.searchTF];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.text = @"上方搜索框内容将通过路由数据每1秒切换一次";
    desc.textColor = [UIColor grayColor];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.frame = CGRectMake(20, 200, self.view.bounds.size.width - 40, 40);
    [self.view addSubview:desc];
    
    self.userInfoLabel = [[UILabel alloc] init];
    self.userInfoLabel.text = [NSString stringWithFormat:@"用户信息：%@", [GGMGJRouter objectForURL:@"user://getUserInfo"]];
    self.userInfoLabel.textColor = [UIColor grayColor];
    self.userInfoLabel.numberOfLines = 0;
    self.userInfoLabel.frame = CGRectMake(20, 240, self.view.bounds.size.width - 40, 100);
    [self.view addSubview:self.userInfoLabel];
}

- (void)startScrollingWords {
    // 1. 获取数据
    NSArray<NSString *> *recommendSearchWordsArray = [GGMGJRouter objectForURL:@"search://recommend/words"];
    
    if (recommendSearchWordsArray.count == 0) {
        self.searchTF.text = @"暂无推荐词";
        return;
    }
    
    __weak typeof(self) wkSelf = self;
    __block NSInteger index = 0;
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(wkSelf) strongSelf = wkSelf;
        if (!strongSelf) return;
        
        strongSelf.searchTF.text = recommendSearchWordsArray[index];
        index = (index + 1) % recommendSearchWordsArray.count;
        
        NSLog(@"%@", strongSelf.searchTF.text);
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

@end
