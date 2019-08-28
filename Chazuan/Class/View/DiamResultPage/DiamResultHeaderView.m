//
//  DiamResultHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamResultHeaderView.h"

@interface DiamResultHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *searchLabel;
@property (nonatomic, readwrite, strong) UIView *textView;
@property (nonatomic, readwrite, strong) UILabel *searchTextLabel;
@property (nonatomic, readwrite, strong) ZGButton *quoteBtn;
@property (nonatomic, readwrite, assign) BOOL hasQuote;
@property (nonatomic, readwrite, strong) ZGButton *cartBtn;
@property (nonatomic, readwrite, strong) ZGButton *orderBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation DiamResultHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
    self.hasQuote = [SingleInstance boolForKey:RapShowKey] && [SingleInstance boolForKey:DiscShowKey];
}

- (void)_setupSubviews {
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.textAlignment = NSTextAlignmentCenter;
    searchLabel.textColor = kHexColor(@"#3882FF");
    searchLabel.font = kFont(15);
    searchLabel.text = @"查询条件";
    self.searchLabel = searchLabel;
    [self addSubview:searchLabel];
    
    if (self.hasQuote) {
        ZGButton *quoteBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [quoteBtn setTitle:@"批量报价" forState:UIControlStateNormal];
        [quoteBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [quoteBtn.titleLabel setFont:kFont(15)];
        self.quoteBtn = quoteBtn;
        [self addSubview:quoteBtn];
    }
    
    ZGButton *cartBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [cartBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [cartBtn.titleLabel setFont:kFont(15)];
    self.cartBtn = cartBtn;
    [self addSubview:cartBtn];
    
    ZGButton *orderBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setTitle:@"生成意向订单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [orderBtn.titleLabel setFont:kFont(15)];
    self.orderBtn = orderBtn;
    [self addSubview:orderBtn];
    
    UIView *textView = [[UIView alloc] init];
    textView.backgroundColor = COLOR_BG;
    self.textView = textView;
    [self addSubview:textView];
    
    UILabel *searchTextLabel = [[UILabel alloc] init];
    searchTextLabel.textColor = kHexColor(@"#4C5860");
    searchTextLabel.font = kFont(12);
    searchTextLabel.numberOfLines = 0;
    self.searchTextLabel = searchTextLabel;
    [textView addSubview:searchTextLabel];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.height.mas_equalTo(ZGCConvertToPx(40));
        make.width.mas_equalTo(self).multipliedBy(0.22);
    }];
    if (self.hasQuote) {
        [self.quoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self.searchLabel.mas_right);
            make.height.mas_equalTo(ZGCConvertToPx(40));
            make.width.mas_equalTo(self).multipliedBy(0.22);
        }];
    }
    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        if (self.hasQuote) make.left.mas_equalTo(self.quoteBtn.mas_right);
        else make.left.mas_equalTo(self.searchLabel.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(40));
        make.width.mas_equalTo(self).multipliedBy(0.26);
    }];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self.cartBtn.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(40));
        make.width.mas_equalTo(self).multipliedBy(0.3);
        make.right.mas_equalTo(self.mas_right);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(40), 0, 0, 0));
    }];
    [self.searchTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(6), ZGCConvertToPx(10), ZGCConvertToPx(6), ZGCConvertToPx(10)));
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
}


@end
