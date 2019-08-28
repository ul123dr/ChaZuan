//
//  OrderCenterViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderCenterViewController.h"
#import "SegmentScrollView.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import <YCMenuView.h>

@interface OrderCenterViewController ()

@property (nonatomic, readwrite, strong) OrderCenterViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIButton *titleBtn;
@property (nonatomic, readwrite, strong) SegmentScrollView *control;

@end

@implementation OrderCenterViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _setupNavigationItem];
    [self _initSubviewsConstraints];
    
//    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, titleViewTitle) deliverOnMainThread] ignore:nil] subscribeNext:^(NSString *title) {
        @strongify(self);
        [self.titleBtn setTitle:title forState:UIControlStateNormal];
        self.viewModel.page = 1;
        [self.viewModel.requestRemoteDataCommand execute:@1];
    }];
    
    [RACObserve(self.viewModel, goodIsNull) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self showTipView:self.tableView andMessage:@"没有符合的数据" andImgPath:nil andBlock:nil];
        } else {
            [self hiddenTipView];
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OrderFooterView *footerView = [OrderFooterView footerWithTableView:tableView];
    if (self.viewModel.shouldMultiSections) {
        OrderGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [footerView bindViewModel:groupViewModel];
    }
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderHeaderView *headerView = [OrderHeaderView headerWithTableView:tableView];
    if (self.viewModel.shouldMultiSections) {
        OrderGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [headerView bindViewModel:groupViewModel];
    }
    return headerView;
}

- (void)_showPopSelectView {
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 1; i <= self.viewModel.titleArray.count; i++) {
        SiftList *list = self.viewModel.titleArray[i-1];
        YCMenuAction *action = [YCMenuAction actionWithTitle:list.name image:self.viewModel.orderType==list.listId.integerValue?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            self.viewModel.orderType = list.listId.integerValue;
        }];
        [items addObject:action];
    }
    
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:140 relyonView:self.titleBtn];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

- (void)_setupSubviews {
    ZGButton *titleBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:@"白钻订单" forState:UIControlStateNormal];
    [titleBtn setImage:ImageNamed(@"head") forState:UIControlStateNormal];
    [titleBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [titleBtn.titleLabel setFont:kFont(18)];
    titleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -ZGCConvertToPx(40), 0, ZGCConvertToPx(40))];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(ZGCConvertToPx(15.5), ZGCConvertToPx(78), ZGCConvertToPx(15.5), ZGCConvertToPx(16))];
    self.navigationItem.titleView = titleBtn;
    self.titleBtn = titleBtn;
    
    SegmentScrollView *control = [SegmentScrollView segmentScrollView];
    [control bindViewModel:self.viewModel];
    self.control = control;
    [self.view addSubview:control];
    
    @weakify(self);
    [[titleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self _showPopSelectView];
    }];
}

- (void)_setupNavigationItem {
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"new_app_03") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.rac_command = self.viewModel.searchCommand;
}

- (void)_initSubviewsConstraints {
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight+ZGCConvertToPx(44), 0, kBottomSpace, 0));
    }];
}

@end
