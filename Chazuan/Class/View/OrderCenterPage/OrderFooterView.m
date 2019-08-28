//
//  OrderFooterView.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderFooterView.h"

@interface OrderFooterView ()

@property (nonatomic, readwrite, strong) OrderGroupViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIView *containtView;
@property (nonatomic, readwrite, strong) ZGButton *confirmBtn;

@end

@implementation OrderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"OrderFooterView";
    OrderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(OrderGroupViewModel *)viewModel {
    self.viewModel = viewModel;
    self.confirmBtn.hidden = !viewModel.showBtn;
    self.contentView.backgroundColor = viewModel.footerBackColor;
}

//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
////        // 创建子控件
////        [self _setupSubviews];
////        // 布局子控件
////        [self _setupSubviewsConstraint];
//    }
//    return self;
//}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    UIView *containtView = [[UIView alloc] init];
    containtView.backgroundColor = UIColor.whiteColor;
    self.containtView = containtView;
    [self.contentView addSubview:containtView];
    
    ZGButton *confirmBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.layer.cornerRadius = 2;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = kHexColor(@"#0E67F4").CGColor;
    [confirmBtn setTitleColor:kHexColor(@"#0E67F4") forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:kFont(13)];
    self.confirmBtn = confirmBtn;
    [containtView addSubview:confirmBtn];
    
    @weakify(self);
    [[confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.comfirmCommand execute:self.viewModel.oldId];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.containtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, ZGCConvertToPx(10), 0));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containtView).offset(ZGCConvertToPx(10));
        make.right.bottom.mas_equalTo(self.containtView).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(ZGCConvertToPx(80));
    }];
}

@end
