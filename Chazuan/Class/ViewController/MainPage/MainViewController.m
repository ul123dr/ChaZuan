//
//  MainViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, readwrite, strong) MainViewModel *viewModel;

@end

@implementation MainViewController

@dynamic viewModel;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupNavigationItem];
}

#pragma mark - override
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[ZGCNotificationCenter rac_addObserverForName:UserDataConfigureCompleteNotification object:nil] subscribeNext:^(NSNotification * note) {
        @strongify(self);
        User *user = note.userInfo[UserDataConfigureCompleteUserInfoKey];
        self.title = user?SharedAppDelegate.manager.company:@"首页";
        [self _updateNavigationItem:kObjectIsNotNil(user)];
    }];
}

#pragma mark - 辅助方法
- (void)_updateNavigationItem:(BOOL)hasLogin {
    // 更改右侧按钮
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(hasLogin?@"new_app_03":@"index_user") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.rac_command = self.viewModel.searchCommand;
}

#pragma mark - 创建页面
- (void)_setupNavigationItem {
    ZGButton *leftBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:ImageNamed(@"shop_cart") forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 0, 11, 22);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.rac_command = self.viewModel.shopCartCommand;
    
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"new_app_03") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.rac_command = self.viewModel.searchCommand;
}

@end
