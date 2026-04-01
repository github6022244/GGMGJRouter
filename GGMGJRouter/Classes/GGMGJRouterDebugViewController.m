//
//  GGMGJRouterDebugViewController.m
//  MGJRouter
//
//  路由调试控制器实现
//

#import "GGMGJRouterDebugViewController.h"
#import "GGMGJRouter.h"
#import "GGMGJRouterDefine.h"
#import "GGMGJRouterDebugWindow.h"

@interface GGMGJRouterDebugViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<GGMGJRouterDebugInfo *> *routes;
@end

@implementation GGMGJRouterDebugViewController

#pragma mark - Lifecycle

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routes = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"路由调试面板";
    self.view.backgroundColor = [UIColor whiteColor];
    [self reloadRoutes];
    
    [self setupTableView];
    [self setupNavigationBar];
    [self setupToolbar];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor systemBlueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)setupToolbar {
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.toolbar.barTintColor = [UIColor whiteColor];
    
    NSArray<UIBarButtonItem *> *items = @[
        [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction)],
        [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)],
        [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportAction)],
        [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)],
    ];
    [self setToolbarItems:items];
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Public Methods

+ (NSArray<GGMGJRouterDebugInfo *> *)allRegisteredRoutes {
    return [GGMGJRouterDebugWindow allRegisteredRoutes];
}

+ (void)clearAllDebugInfo {
    [GGMGJRouterDebugWindow clearAllDebugInfo];
}

+ (void)exportRoutesToPasteboard {
    [GGMGJRouterDebugWindow exportRoutesToPasteboard];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"RouteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    GGMGJRouterDebugInfo *info = self.routes[indexPath.row];
    cell.textLabel.text = info.URLPattern;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    if (info.parameters.count > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"参数：%lu 个", (unsigned long)info.parameters.count];
    } else {
        cell.detailTextLabel.text = @"无参数";
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGMGJRouterDebugInfo *info = self.routes[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试路由"
                                                                   message:info.URLPattern
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *param in info.parameters) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = param;
            textField.tag = [info.parameters indexOfObject:param];
        }];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *url = info.URLPattern;
        NSMutableArray *params = [NSMutableArray array];
        
        for (UITextField *textField in alert.textFields) {
            if (textField.text.length > 0) {
                [params addObject:textField.text];
            }
        }
        
        if (params.count > 0) {
            url = [MGJRouter generateURLWithPattern:url parameters:params];
        }
        
        [GGMGJRouter openURL:url withUserInfo:@{
            @"userInfo": @"GGMGJRouterDebug",
        } completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Actions

- (void)clearAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认清空"
                                                                   message:@"确定要清空所有路由记录吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.class clearAllDebugInfo];
        [self.routes removeAllObjects];
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exportAction {
    [self.class exportRoutesToPasteboard];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导出成功"
                                                                   message:@"路由表已复制到剪贴板"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingAction {
    NSString *message = [NSString stringWithFormat:@"在接收消息时是否允许MGJRouterParam合并userInfo里的参数？默认YES，当前：%@\n这个设置只影响MGJRouterParam", MGJRouterParam.useUserInfoAsParam ? @"YES" : @"NO"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MGJRouterParam.useUserInfoAsParam = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        MGJRouterParam.useUserInfoAsParam = YES;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reloadRoutes {
    self.routes = [[self.class allRegisteredRoutes] mutableCopy];
    [self.tableView reloadData];
}

@end
