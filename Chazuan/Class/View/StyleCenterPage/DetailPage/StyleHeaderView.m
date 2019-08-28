//
//  StyleHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/29.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleHeaderView.h"

@interface StyleHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;

@end

@implementation StyleHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"StyleHeaderView";
    StyleHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(header)) {
        // 缓冲池没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (void)bindViewModel:(GoodInfoGroupViewModel *)viewModel {
    self.titleLabel.attributedText = viewModel.attrHeader;
    self.contentView.backgroundColor = kHexColor(@"#F5F6FA");
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFont(13);
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

- (void)_setupSubviewsConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(11), 0, 0, 0));
    }];
}

@end
