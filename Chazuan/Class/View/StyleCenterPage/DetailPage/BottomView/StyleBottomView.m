//
//  StyleBottomView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleBottomView.h"
#import "StyleDetailViewModel.h"
#import "UpDownButton.h"

@interface StyleBottomView ()

@property (nonatomic, readwrite, assign) StyleType type;
@property (nonatomic, readwrite, strong) ZGButton *homeBtn;
@property (nonatomic, readwrite, strong) ZGButton *addCartBtn;
@property (nonatomic, readwrite, strong) ZGButton *orderBtn;

@end

@implementation StyleBottomView

- (instancetype)initWithType:(StyleType)type {
    self = [super init];
    if (self) {
        self.type = type;
        [self _setup];
        [self _setupSubviews];
        [self _setupConstraints];
    }
    return self;
}

- (void)_setup {
    self.layer.shadowColor = kHexColor(@"#C0C0C0").CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, -3);
}

- (void)_setupSubviews {
    ZGButton *homeBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setBackgroundColor:UIColor.whiteColor];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    [homeBtn setTitleColor:kHexColor(@"#020D2C") forState:UIControlStateNormal];
    [homeBtn setImage:ImageNamed(@"styleDetail_home") forState:UIControlStateNormal];
    [homeBtn.titleLabel setFont:kFont(12)];
    homeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    homeBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 18, 20, -18);
    homeBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -18, 5, 18);
    self.homeBtn = homeBtn;
    
    ZGButton *addCartBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [addCartBtn setBackgroundColor:kHexColor(@"#DFE3EF")];
    [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartBtn setTitleColor:kHexColor(@"#020D2C") forState:UIControlStateNormal];
    [addCartBtn.titleLabel setFont:kFont(16)];
    self.addCartBtn = addCartBtn;
    
    ZGButton *orderBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setBackgroundColor:kHexColor(@"#3882FF")];
    [orderBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [orderBtn.titleLabel setFont:kFont(16)];
    self.orderBtn = orderBtn;
    
    if (self.type == StyleZT) {
        [self addSubview:orderBtn];
    } else {
        [self addSubview:homeBtn];
        [self addSubview:addCartBtn];
        [self addSubview:orderBtn];
    }
}

- (void)_setupConstraints {
    if (self.type == StyleZT) {
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    } else {
        [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(80);
        }];
        [self.addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self.homeBtn.mas_right);
        }];
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self.addCartBtn.mas_right);
            make.width.mas_equalTo(self.addCartBtn);
        }];
    }
}

@end
