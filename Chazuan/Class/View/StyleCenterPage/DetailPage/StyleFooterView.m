//
//  StyleFooterView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/29.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleFooterView.h"

@interface StyleFooterView ()

@property (nonatomic, readwrite, strong) ZGButton *addBtn;
@property (nonatomic, readwrite, strong) ZGButton *resetBtn;

@end

@implementation StyleFooterView

+ (instancetype)footerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"StyleFooterView";
    StyleFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(GoodInfoGroupViewModel *)viewModel {
    self.addBtn.rac_command = viewModel.addCommond;
    self.resetBtn.rac_command = viewModel.resetCommond;
    self.contentView.backgroundColor = kHexColor(@"#F5F6FA");
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    ZGButton *addBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundColor:kHexColor(@"#F5F6FA")];
    addBtn.layer.cornerRadius = ZGCConvertToPx(21);
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = kHexColor(@"#3882FF").CGColor;
    [addBtn setTitleColor:kHexColor(@"#3882FF") forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:kFont(15)];
    self.addBtn = addBtn;
    [self.contentView addSubview:addBtn];
    
    ZGButton *resetBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setBackgroundColor:kHexColor(@"#F5F6FA")];
    resetBtn.layer.cornerRadius = ZGCConvertToPx(21);
    resetBtn.layer.borderWidth = 1;
    resetBtn.layer.borderColor = kHexColor(@"#3882FF").CGColor;
    [resetBtn setTitleColor:kHexColor(@"#3882FF") forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:kFont(15)];
    self.resetBtn = resetBtn;
    [self.contentView addSubview:resetBtn];
}

- (void)_setupSubviewsConstraint {
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView).offset(ZGCConvertToPx(-10));
//        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(10), ZGCConvertToPx(10), ZGCConvertToPx(62), ZGCConvertToPx(10)));
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addBtn.mas_bottom).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView).offset(ZGCConvertToPx(-10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.addBtn);
//        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(62), ZGCConvertToPx(10), ZGCConvertToPx(10), ZGCConvertToPx(10)));
    }];
}

@end
