//
//  AccountView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountView.h"

@interface AccountView ()

@property (nonatomic, readwrite, strong) UIImageView *icon;
@property (nonatomic, readwrite, strong) UITextField *accountField;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation AccountView

+ (instancetype)accountView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self _setup];
        // 创建控件
        [self _setupSubviews];
        // 控件布局
        [self _setupSubviewsConstraint];
    }
    return self;
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)_setupSubviews {
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:ImageNamed(@"login_03")];
    self.icon = icon;
    [self addSubview:icon];
    
    UITextField *accountField = [[UITextField alloc] init];
    accountField.placeholder = @"请输入用户名";
    accountField.font = kFont(14);
    accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    self.accountField = accountField;
    [self addSubview:accountField];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = kHexColor(@"#1C2B36");
    self.dividerLine = dividerLine;
    [self addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(15));
        make.bottom.mas_equalTo(self).offset(ZGCConvertToPx(-15));
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(3));
        make.bottom.mas_equalTo(self.mas_bottom).offset(ZGCConvertToPx(-3));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-3));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
