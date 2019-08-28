//
//  AccountAddViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountAddViewController.h"
#import "AccountAddBottomView.h"
#import "YCMenuView.h"

@interface AccountAddViewController ()

@property (nonatomic, readwrite, strong) AccountAddViewModel *viewModel;
@property (nonatomic, readwrite, strong) AccountAddBottomView *bottomView;

@end

@implementation AccountAddViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _initSubviewsConstraints];
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
    
    // HUD
    [self.viewModel.addCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
}

- (void)_showPopView:(RACTuple *)x {
    NSInteger type = [x.first integerValue];
    NSArray *list;
    if (type == 1) {
        list = self.viewModel.userSelectList;
    } else if (type == 2) {
        list = self.viewModel.sellerSelectList;
    } else if (type == 3) {
        list = self.viewModel.buySelectList;
    } else if (type == 4) {
        list = self.viewModel.vipSelectList;
    } else if (type == 5) {
        list = self.viewModel.userTypeSelectList;
    } else if (type == 6) {
        list = self.viewModel.roleSelectList;
    }
    if (!list) return;
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < list.count; i++) {
        SiftList *sift = list[i];
        BOOL select = [sift.name isEqualToString:x.third];
        @weakify(self);
        YCMenuAction *action = [YCMenuAction actionWithTitle:formatString(sift.name) image:select?ImageNamed(@"checkbox_selected"):ImageNamed(@"nor") handler:^(YCMenuAction *action) {
            @strongify(self);
            if (type == 1) {
                self.viewModel.addUser.fromList = sift.listId;
            } else if (type == 2) {
                self.viewModel.addUser.seller = sift.listId;
            } else if (type == 3) {
                self.viewModel.addUser.buyer = sift.listId;
            } else if (type == 4) {
                self.viewModel.addUser.level = sift.listId.integerValue;
            } else if (type == 5) {
                self.viewModel.addUser.userType = sift.listId.integerValue;
            } else if (type == 6) {
                self.viewModel.addUser.fromRole = sift.listId;
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

- (void)_setupSubviews {
    AccountAddBottomView *bottomView = [[AccountAddBottomView alloc] init];
    bottomView.resetBtn.rac_command = self.viewModel.resetCommand;
    bottomView.addBtn.rac_command = self.viewModel.addCommand;
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
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
