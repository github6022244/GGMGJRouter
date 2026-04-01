//
//  GGViewController.m
//  GGMGJRouter
//
//  Created by github6022244 on 03/30/2026.
//  Copyright (c) 2026 github6022244. All rights reserved.
//

#import "GGViewController.h"
#import <GGMGJRouter+GGModuleInitializer.h>
#import <MGJRouter+GG.h>

@interface GGViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary *> *functionList;

@end

@implementation GGViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GGMGJRouter 功能列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    [self setupUI];
}

#pragma mark - Setup

- (void)setupData {
    self.functionList = @[
        @{
            @"title": @"初始化module示例",
            @"desc": @"展示首页渲染完成初始化module",
            @"class": @"GGInitModulesViewController",
        },
        @{
            @"title": @"路由通信示例",
            @"desc": @"点击按钮触发 'test' 路由并接收回调",
            @"class": @"GGRouterEventDemoViewController",
        },
        @{
            @"title": @"强类型参数封装示例",
            @"desc": @"点击按钮用Request封装参数请求路由",
            @"class": @"GGMGJTypeSafeViewController",
        },
        @{
            @"title": @"路由拦截器示例",
            @"desc": @"",
            @"class": @"GGMGJInterceptorViewController",
        },
        @{
            @"title": @"生命周期管理示例",
            @"desc": @"",
            @"class": @"GGMGJLifecycleViewController",
        },
        @{
            @"title": @"调试面板示例",
            @"desc": @"",
            @"class": @"GGMGJDebugViewController",
        },
    ];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80.0;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseID];
    }
    
    cell.backgroundColor = UIColor.whiteColor;
    cell.contentView.backgroundColor = UIColor.whiteColor;
    
    NSDictionary *item = self.functionList[indexPath.row];
    
    // 配置主标题
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text = item[@"desc"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.functionList[indexPath.row];
    NSString *vcClass_String = item[@"class"];
    
    if (vcClass_String) {
        UIViewController *vc = [[NSClassFromString(vcClass_String) alloc] init];
        vc.title = item[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
