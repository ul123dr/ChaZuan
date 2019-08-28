//
//  SearchButtonFooterView.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchFooterView.h"

@interface SearchFooterView ()

@property (nonatomic, readwrite, strong) ZGButton *confirmBtn;

@end

@implementation SearchFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"SearchFooterView";
    SearchFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(SearchGroupViewModel *)viewModel {
    self.confirmBtn.rac_command = viewModel.clearCommand;
    self.contentView.backgroundColor = viewModel.footerBackColor;
}

//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        // 创建子控件
//        [self _setupSubviews];
//        // 布局子控件
//        [self _setupSubviewsConstraint];
//    }
//    return self;
//}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    ZGButton *confirmBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.layer.cornerRadius = 2;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = kHexColor(@"#7B7B7B").CGColor;
    [confirmBtn setTitleColor:kHexColor(@"#7B7B7B") forState:UIControlStateNormal];
    [confirmBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:kFont(16)];
    self.confirmBtn = confirmBtn;
    [self.contentView addSubview:confirmBtn];
}

- (void)_setupSubviewsConstraint {
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(50), ZGCConvertToPx(62.5), ZGCConvertToPx(50), ZGCConvertToPx(62.5)));
    }];
}

@end
