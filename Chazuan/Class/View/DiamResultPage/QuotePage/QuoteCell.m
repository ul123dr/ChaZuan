//
//  QuoteCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QuoteCell.h"

@interface QuoteCell ()

/// viewModel
@property (nonatomic, readwrite, strong) QuoteItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) UILabel *contentLabel;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation QuoteCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"QuoteCell";
    QuoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(QuoteItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [RACObserve(viewModel, content) subscribeNext:^(NSString *content) {
        @strongify(self);
        self.contentLabel.text = content;
        CGFloat height = sizeOfString(content, kFont(14), kScreenW-ZGCConvertToPx(20)).height+5;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - 辅助方法

- (void)_setupSubviews {
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = kFont(14);
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(12.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(20));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

@end
