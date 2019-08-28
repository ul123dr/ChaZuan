//
//  TableViewFooterView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "TableViewFooterView.h"

@interface TableViewFooterView ()

@property (nonatomic, readwrite, strong) CommonGroupViewModel *viewModel;
// 无数据提示
@property (nonatomic, readwrite, strong) UILabel *contentLabel;

@end

@implementation TableViewFooterView

+ (instancetype)footerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"TableViewFooterView";
    TableViewFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(CommonGroupViewModel *)viewModel {
    self.contentLabel.text = viewModel.footer;
    self.contentView.backgroundColor = viewModel.footerBackColor;
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
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = kHexColor(@"#999999");
    contentLabel.font = kFont(12);
    contentLabel.text = @"已经到底了~";
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
}

- (void)_setupSubviewsConstraint {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5.f, ZGCConvertToPx(10), 5.f, ZGCConvertToPx(10)));
    }];
}

@end
