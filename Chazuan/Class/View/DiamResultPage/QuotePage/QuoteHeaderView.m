//
//  QuoteHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QuoteHeaderView.h"

@interface QuoteHeaderView ()

@property (nonatomic, readwrite, strong) QuoteGroupViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIImageView *icon;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) ZGButton *cBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation QuoteHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"QuoteHeaderView";
    QuoteHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(QuoteGroupViewModel *)viewModel {
    self.viewModel = viewModel;
    RAC(self.titleLabel, text) = [RACObserve(viewModel, title) takeUntil:self.rac_prepareForReuseSignal];
    self.contentView.backgroundColor = UIColor.whiteColor;
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    UIImageView *icon = [[UIImageView alloc] initWithImage:ImageNamed(@"quote_img")];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#1C2B36");
    titleLabel.font = kFont(16);
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    ZGButton *cBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [cBtn setTitle:@"复制" forState:UIControlStateNormal];
    [cBtn.titleLabel setFont:kFont(16)];
    [cBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#3882FF")] forState:UIControlStateNormal];
    cBtn.layer.cornerRadius = 8;
    self.cBtn = cBtn;
    [self.contentView addSubview:cBtn];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[cBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.cSub sendNext:self.viewModel.itemViewModels.firstObject];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(14));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-14));
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(6));
        make.left.mas_equalTo(self.icon.mas_right).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-6));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
    }];
    
    [self.cBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(8));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-8));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(1);
    }];
}


@end
