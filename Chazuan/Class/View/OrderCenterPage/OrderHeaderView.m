//
//  OrderHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderHeaderView.h"

@interface OrderHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *orderLabel;
@property (nonatomic, readwrite, strong) UILabel *statusLabel;

@end

@implementation OrderHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"OrderHeaderView";
    OrderHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(OrderGroupViewModel *)viewModel {
    RAC(self.orderLabel, text) = [RACObserve(viewModel, orderNo) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.statusLabel, text) = [RACObserve(viewModel, orderStatus) takeUntil:self.rac_prepareForReuseSignal];
//    self.orderLabel.text = viewModel.orderNo;
//    self.statusLabel.text = viewModel.orderStatus;
    self.contentView.backgroundColor = viewModel.headerBackColor;
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.textColor = kHexColor(@"#1C2B36");
    orderLabel.font = kFont(13);
    self.orderLabel = orderLabel;
    [self.contentView addSubview:orderLabel];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = kHexColor(@"#0E67F4");
    statusLabel.font = kFont(13);
    self.statusLabel = statusLabel;
    [self.contentView addSubview:statusLabel];
}

- (void)_setupSubviewsConstraint {
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.orderLabel.mas_right);
        make.width.mas_equalTo(ZGCConvertToPx(80));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
    }];
}

@end
