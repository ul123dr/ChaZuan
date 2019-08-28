//
//  AccountViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountViewController.h"
#import "SearchView.h"
#import "SwitchView.h"
#import <YCMenuView.h>

@interface AccountViewController ()

@property (nonatomic, readwrite, strong) AccountViewModel *viewModel;
@property (nonatomic, readwrite, strong) SwitchView *switchView;
@property (nonatomic, readwrite, strong) SearchView *searchView;
@property (nonatomic, readwrite, strong) UILabel *countLabel;

@end

@implementation AccountViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setTitleView];
    [self _setNavigationItem];
    [self _setupSubviews];
    [self _setupSubviewsConstraint];
    
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    
    [RACObserve(self.switchView, switchType) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (self.viewModel.type == x.integerValue) return;
        self.viewModel.type = x.integerValue;
        [self.tableView layoutIfNeeded]; //这句是关键
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [self.tableView.mj_footer resetNoMoreData];
    }];
    
    [RACObserve(self.viewModel, count) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.countLabel.text = [NSString stringWithFormat:@"共 %@ 个%@", x, self.viewModel.type==1?@"会员":@"员工"];
    }];
    
    [self.viewModel.searchTypeSub subscribeNext:^(id input) {
        @strongify(self);
        [self _showPopSelectView];
    }];
}

- (void)_showPopSelectView {
    NSArray *list = @[@"账号",@"姓名",@"手机"];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 1; i <= list.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:list[i-1] image:self.viewModel.searchType==i?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            self.viewModel.searchType = i;
        }];
        [items addObject:action];
    }
    
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:100 relyonView:self.searchView.selectBtn];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

#pragma mark - 创建页面
- (void)_setTitleView {
    if (self.viewModel.services.client.currentUser.userType == 99 || self.viewModel.services.client.currentUser.userType == 5) {
        SwitchView *switchView = [SwitchView switchView];
        switchView.leftTitle = @"会员";
        switchView.rightTitle = @"员工";
        self.switchView = switchView;
        self.navigationItem.titleView = switchView;
    }
}

- (void)_setNavigationItem {
    ZGButton *addBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:ImageNamed(@"account_add") forState:UIControlStateNormal];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    addBtn.rac_command = self.viewModel.addCommand;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
}

- (void)_setupSubviews {
    SearchView *searchView = [SearchView searchView];
    [searchView bindViewModel:self.viewModel];
    self.searchView = searchView;
    [self.view addSubview:searchView];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = kHexColor(@"#B2B7BA");
    countLabel.font = kFont(12);
    countLabel.backgroundColor = COLOR_BG;
    self.countLabel = countLabel;
    [self.view addSubview:countLabel];
}

- (void)_setupSubviewsConstraint {
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(47);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ZGCConvertToPx(41));
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight+ZGCConvertToPx(88), 0, kBottomSpace, 0));
    }];
}

@end
