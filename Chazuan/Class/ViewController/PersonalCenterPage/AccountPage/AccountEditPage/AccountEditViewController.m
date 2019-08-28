//
//  AccountEditViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountEditViewController.h"
#import "YCMenuView.h"

@interface AccountEditViewController ()

@property (nonatomic, readwrite, strong) AccountEditViewModel *viewModel;
@property (nonatomic, readwrite, strong) ZGButton *editBtn;

@end

@implementation AccountEditViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setNavigationItem];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.selectSub subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [self _showPopView:x];
    }];
    [self.viewModel.reloadSub subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    RAC(self.editBtn, selected) = RACObserve(self.viewModel, isEdit);
}

- (void)_showPopView:(RACTuple *)x {
    NSInteger type = [x.first integerValue];
    NSArray *list;
    if (type == 2) {
        list = self.viewModel.sellerSelectList;
    } else if (type == 3) {
        list = self.viewModel.buySelectList;
    } else if (type == 4) {
        list = self.viewModel.vipSelectList;
    } else if (type == 5) {
        list = self.viewModel.userTypeSelectList;
    }
    if (!list) return;
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < list.count; i++) {
        SiftList *sift = list[i];
        BOOL select = [sift.name isEqualToString:x.third];
        @weakify(self);
        YCMenuAction *action = [YCMenuAction actionWithTitle:formatString(sift.name) image:select?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            @strongify(self);
            if (type == 2) {
                self.viewModel.addUser.seller = sift.listId;
            } else if (type == 3) {
                self.viewModel.addUser.buyer = sift.listId;
            } else if (type == 4) {
                self.viewModel.addUser.level = sift.listId.integerValue;
            } else if (type == 5) {
                self.viewModel.addUser.userType = sift.listId.integerValue;
            }
        }];
        [items addObject:action];
    }
    // 创建YCMenuView(根据关联点或者关联视图)
    YCMenuView *view = [YCMenuView menuWithActions:[items copy] width:250 relyonView:x.second];
    
    // 自定义设置
    view.menuColor = [UIColor whiteColor];
    view.separatorColor = COLOR_LINE;
    view.maxDisplayCount = 5;  // 最大展示数量（其他的需要滚动才能看到）
    view.textFont = kFont(15);
    
    // 显示
    [view show];
}

- (void)_setNavigationItem {
    ZGButton *editBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"保存" forState:UIControlStateSelected];
    [editBtn.titleLabel setFont:kFont(15)];
    self.editBtn = editBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    if (IS_IPHONE_5_OR_LESS)
        editBtn.frame = CGRectMake(0, 0, 44, 44);
    
    @weakify(self);
    [[editBtn rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        [self.viewModel.editCommand execute:@(sender.selected)];
    }];
}

@end
