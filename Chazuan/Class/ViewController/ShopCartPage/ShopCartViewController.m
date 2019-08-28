//
//  ShopCartViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/19.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShopCartBottomView.h"

@interface ShopCartViewController ()

@property (nonatomic, readwrite, strong) ShopCartViewModel *viewModel;
@property (nonatomic, readwrite, strong) ShopCartBottomView *bottomView;
@property (nonatomic, readwrite, strong) ZGButton *selectAllBtn;

@end

@implementation ShopCartViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _setupNavigationItem];
    [self _setupSubviewsConstraint];
    
    [self.viewModel.requestRateCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [RACObserve(self.viewModel, goodIsNull) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            self.selectAllBtn.selected = NO;
            [self showTipView:self.tableView andMessage:@"没有符合的数据" andImgPath:nil andBlock:nil];
        } else {
            [self hiddenTipView];
        }
    }];
    
    // 错误处理
    [[RACObserve(self.viewModel, error) ignore:nil] subscribeNext:^(NSError *err) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:err.userInfo[HTTPServiceErrorDescriptionKey]];
    }];
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    ShopCartBottomView *bottomView = [ShopCartBottomView cartButtonView];
    [bottomView bindViewModel:self.viewModel];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
}

- (void)_setupNavigationItem {
    ZGButton *selectAllBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [selectAllBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectAllBtn.titleLabel setFont:kFont(15)];
    self.selectAllBtn = selectAllBtn;
    UIBarButtonItem *selectAllItem = [[UIBarButtonItem alloc] initWithCustomView:selectAllBtn];
    self.navigationItem.rightBarButtonItem = selectAllItem;
    if (IS_IPHONE_5_OR_LESS)
        selectAllBtn.frame = CGRectMake(0, 0, 44, 44);
    
    @weakify(self);
    [[[selectAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.dataSource.count == 0) return;
        sender.selected = !sender.selected;
        [self.viewModel.selectAllCommand execute:@(sender.selected)];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomHeight, 0));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kScreenH-kBottomHeight, 0, 0, 0));
    }];
}

@end
