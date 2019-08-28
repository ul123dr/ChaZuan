//
//  FancySearchViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancySearchViewController.h"
#import "SearchBottomView.h"
#import <YCMenuView.h>
#import "DiamHeaderView.h"
#import "DiamFooterView.h"

@interface FancySearchViewController ()

@property (nonatomic, readwrite, strong) FancySearchViewModel *viewModel;
@property (nonatomic, readwrite, strong) SearchBottomView *bottomView;

@end

@implementation FancySearchViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _setupNavigationItem];
    [self _initSubviewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.sizeSub subscribeNext:^(ZGButton *button) {
        @strongify(self);
        [self _shopSizePopView:button isSize:YES];
    }];
    
    [self.viewModel.certSub subscribeNext:^(ZGButton *button) {
        @strongify(self);
        [self _shopSizePopView:button isSize:NO];
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DiamFooterView *footerView = [DiamFooterView footerWithTableView:tableView];
    DiamGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [footerView bindViewModel:groupViewModel];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DiamHeaderView *headerView = [DiamHeaderView headerWithTableView:tableView];
    DiamGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [headerView bindViewModel:groupViewModel];
    return headerView;
}

- (void)_shopSizePopView:(ZGButton *)btn isSize:(BOOL)type {
    NSMutableArray *items = [NSMutableArray array];
    NSArray *cycleArr = type?self.viewModel.sizeArray:self.viewModel.certArray;
    for (int i = 0; i < cycleArr.count; i++) {
        NSString *title = cycleArr[i];
        YCMenuAction *action = [YCMenuAction actionWithTitle:title image:[btn.currentTitle isEqualToString:title]?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            if (type) {
                self.viewModel.sizeBtnTitle = title;
                if (i == 0) {
                    self.viewModel.diam.sizeMin = @"";
                    self.viewModel.diam.sizeMax = @"";
                } else {
                    NSArray *priceArray = [title componentsSeparatedByString:@"-"];
                    self.viewModel.diam.sizeMin = [priceArray.firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    self.viewModel.diam.sizeMax = [priceArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
            } else {
                self.viewModel.certBtnTitle = title;
            }
        }];
        [items addObject:action];
    }
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:150 relyonView:btn];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

- (void)_setupSubviews {
    SearchBottomView *bottomView = [[SearchBottomView alloc] init];
    bottomView.resetBtn.rac_command = self.viewModel.resetCommand;
    bottomView.searchBtn.rac_command = self.viewModel.searchCommand;
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
}

- (void)_setupNavigationItem {
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"new_app_03") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.rac_command = self.viewModel.navSearchCommand;
}

- (void)_initSubviewsConstraints {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomHeight, 0));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kScreenH-kBottomHeight, 0, 0, 0));
    }];
}

@end
