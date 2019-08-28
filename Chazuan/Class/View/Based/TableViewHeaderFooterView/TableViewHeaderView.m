//
//  TableViewHeaderView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "TableViewHeaderView.h"

@interface TableViewHeaderView ()
// 无数据提示
@property (nonatomic, readwrite, strong) UILabel *contentLabel;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation TableViewHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"TableViewHeaderView";
    TableViewHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(CommonGroupViewModel *)viewModel {
    self.contentLabel.text = viewModel.header;
    self.contentView.backgroundColor = viewModel.headerBackColor;
    self.dividerLine.hidden = viewModel.hideDividerLine;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _setup];
        // 创建子控件
        [self _setupSubviews];
        // 布局子控件
        [self _setupSubviewsConstraint];
    }
    return self;
}

#pragma mark - 辅助方法
- (void)_setup {
    self.contentView.clipsToBounds = YES;
}

- (void)_setupSubviews {
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = kHexColor(@"#1C2B36");
    contentLabel.font = kFont(15);
    contentLabel.text = @"我是头部~";
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(10), 0, ZGCConvertToPx(10)));
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

@end
