//
//  DiamHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/4.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamHeaderView.h"

@interface DiamHeaderView ()

@property (nonatomic, readwrite, strong) DiamGroupViewModel *viewModel;

@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;
@property (nonatomic, readwrite, strong) UILabel *valueLabel;
@property (nonatomic, readwrite, strong) ZGButton *openBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation DiamHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"DiamHeaderView";
    DiamHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(header)) {
        // 缓冲池没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (void)bindViewModel:(DiamGroupViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    RAC(self.titleLabel, text) = [RACObserve(viewModel, titleStr) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.valueLabel, text) = [[RACObserve(viewModel, valueStr) takeUntil:self.rac_prepareForReuseSignal] map:^id(NSString *value) {
        @strongify(self);
        CGFloat width = sizeOfString(value, kFont(12), CGFLOAT_MAX).width+5;
        [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        self.scrollView.contentSize = CGSizeMake(width, ZGCConvertToPx(44));
        if (width > self.scrollView.size.width) [self.scrollView scrollToRight];
        [self.contentView layoutIfNeeded];
        return value;
    }];
    self.contentView.backgroundColor = viewModel.headerBackColor;
    RAC(self.openBtn, selected) = [RACObserve(viewModel, closed) takeUntil:self.rac_prepareForReuseSignal];
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#1C2B36");
    titleLabel.font = kBoldFont(15);
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.contentView addSubview:scrollView];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = kHexColor(@"#3882FF");
    valueLabel.font = kFont(12);
    self.valueLabel = valueLabel;
    [scrollView addSubview:valueLabel];
    
    ZGButton *openBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [openBtn setImage:ImageNamed(@"select_bottom") forState:UIControlStateNormal];
    [openBtn setImage:ImageNamed(@"select_top") forState:UIControlStateSelected];
    [openBtn setImageEdgeInsets:UIEdgeInsetsMake(ZGCConvertToPx(17), ZGCConvertToPx(13), ZGCConvertToPx(17), ZGCConvertToPx(13))];
    self.openBtn = openBtn;
    [self.contentView addSubview:openBtn];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.operation) self.viewModel.operation();
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(ZGCConvertToPx(40));
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(44));
        make.width.mas_equalTo(0);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.titleLabel);
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

@end
