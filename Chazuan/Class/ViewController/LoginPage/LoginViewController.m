//
//  LoginViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountView.h"
#import "PasswordView.h"

@interface LoginViewController ()

@property (nonatomic, readwrite, strong) LoginViewModel *viewModel;
@property (nonatomic, readwrite, strong) AccountView *accountView;
@property (nonatomic, readwrite, strong) PasswordView *passwordView;
@property (nonatomic, readwrite, strong) ZGButton *rememberPwdBtn;
@property (nonatomic, readwrite, strong) ZGButton *autoLoginBtn;
@property (nonatomic, readwrite, strong) ZGButton *loginBtn;

@end

@implementation LoginViewController

@dynamic viewModel;

/* 先把 view 改成 scrollview */
- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
    [self _setupSubviews];
    [self _setupSubviewsConstraint];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.accountView.accountField.text = self.viewModel.userName;
    self.passwordView.passwordField.text = self.viewModel.userPassword;
    
    RAC(self.viewModel, userName) = [RACSignal merge:@[RACObserve(self.accountView.accountField, text),self.accountView.accountField.rac_textSignal]];
    RAC(self.viewModel, userPassword) = [RACSignal merge:@[RACObserve(self.passwordView.passwordField, text),self.passwordView.passwordField.rac_textSignal]];
    RACChannelTo(self.rememberPwdBtn, selected) = RACChannelTo(self.viewModel, rememberPwd);
    RACChannelTo(self.autoLoginBtn, selected) = RACChannelTo(self.viewModel, autoLogin);
    
    // HUD
    [self.viewModel.loginCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    
    // 错误处理
    [[RACObserve(self.viewModel, error) ignore:nil] subscribeNext:^(NSError *err) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:err.userInfo[HTTPServiceErrorDescriptionKey]];
    }];
}

#pragma mark - 创建页面
- (void)_setup {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.bounces = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    // 适配 iOS 11
    ZGCAdjustsScrollViewInsets_Never(scrollView);
}

- (void)_setupSubviews {
    AccountView *accountView = [AccountView accountView];
    self.accountView = accountView;
    [self.view addSubview:accountView];
    
    PasswordView *passwordView = [PasswordView passwordView];
    self.passwordView = passwordView;
    [self.view addSubview:passwordView];
    
    ZGButton *rememberPwdBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rememberPwdBtn setTitle:@" 记住密码" forState:UIControlStateNormal];
    [rememberPwdBtn.titleLabel setFont:kFont(10)];
    [rememberPwdBtn setTitleColor:kHexColor(@"#4C5860") forState:UIControlStateNormal];
    [rememberPwdBtn setImage:ImageNamed(@"unselect") forState:UIControlStateNormal];
    [rememberPwdBtn setImage:ImageNamed(@"select") forState:UIControlStateSelected];
    rememberPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(11), ZGCConvertToPx(3), ZGCConvertToPx(11), ZGCConvertToPx(50));
    self.rememberPwdBtn = rememberPwdBtn;
    [self.view addSubview:rememberPwdBtn];
    
    ZGButton *autoLoginBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [autoLoginBtn setTitle:@" 自动登录" forState:UIControlStateNormal];
    [autoLoginBtn.titleLabel setFont:kFont(10)];
    [autoLoginBtn setTitleColor:kHexColor(@"#4C5860") forState:UIControlStateNormal];
    [autoLoginBtn setImage:ImageNamed(@"unselect") forState:UIControlStateNormal];
    [autoLoginBtn setImage:ImageNamed(@"select") forState:UIControlStateSelected];
    autoLoginBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(11), ZGCConvertToPx(3), ZGCConvertToPx(11), ZGCConvertToPx(50));
    self.autoLoginBtn = autoLoginBtn;
    [self.view addSubview:autoLoginBtn];
    
    ZGButton *loginBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:kFont(16)];
    [loginBtn setBackgroundColor:COLOR_MAIN];
    loginBtn.layer.cornerRadius = 2;
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    @weakify(self);
    [[rememberPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        sender.selected = !sender.selected;
    }];
    [[autoLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        sender.selected = !sender.selected;
    }];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (kStringIsEmpty(self.viewModel.userName)) {
            [SVProgressHUD showInfoWithStatus:@"请输入用户账号"];
            return;
        }
        if (kStringIsEmpty(self.viewModel.userPassword)) {
            [SVProgressHUD showInfoWithStatus:@"请输入用户密码"];
            return;
        }
        [self.viewModel.loginCommand execute:nil];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(ZGCConvertToPx(38));
        make.right.mas_equalTo(self.view.mas_right).offset(ZGCConvertToPx(-38));
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).offset(ZGCConvertToPx(20));
        make.left.mas_equalTo(self.view).offset(ZGCConvertToPx(38));
        make.right.mas_equalTo(self.view.mas_right).offset(ZGCConvertToPx(-38));
        make.height.mas_equalTo(ZGCConvertToPx(44));
        make.center.mas_equalTo(self.view);
    }];
    
    [self.rememberPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.passwordView);
        make.width.mas_equalTo(ZGCConvertToPx(65));
        make.height.mas_equalTo(ZGCConvertToPx(34));
    }];
    
    [self.autoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordView.mas_bottom).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.rememberPwdBtn.mas_right).offset(ZGCConvertToPx(5));
        make.width.mas_equalTo(self.rememberPwdBtn);
        make.height.mas_equalTo(self.rememberPwdBtn);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rememberPwdBtn.mas_bottom).offset(ZGCConvertToPx(30));
        make.left.mas_equalTo(self.view).offset(ZGCConvertToPx(38));
        make.right.mas_equalTo(self.view.mas_right).offset(ZGCConvertToPx(-38));
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
}

@end
