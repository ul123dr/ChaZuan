//
//  AccountEditCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountEditCell.h"

@interface AccountEditCell ()

// viewModel
@property (nonatomic, readwrite, strong) AccountEditItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UILabel *valueLabel;
@property (nonatomic, readwrite, strong) ZGButton *resetBtn;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation AccountEditCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"AccountEditCell";
    AccountEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(AccountEditItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleL.text = viewModel.title;
    RAC(self.valueLabel, text) = [RACObserve(viewModel, value) takeUntil:self.rac_prepareForReuseSignal];
    self.resetBtn.rac_command = viewModel.resetPwdCommand;
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
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kFont(15);
    titleL.textColor = kHexColor(@"#98A2A9");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = kHexColor(@"#1C2B36");
    valueLabel.font = kFont(15);
    valueLabel.numberOfLines = 0;
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
    ZGButton *resetBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [resetBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [resetBtn setBackgroundColor:COLOR_MAIN];
    [resetBtn.titleLabel setFont:kFont(12)];
    resetBtn.layer.cornerRadius = 4.0f;
    self.resetBtn = resetBtn;
    [self.contentView addSubview:resetBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ZGCConvertToPx(140));
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(14.5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-14.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.width.mas_equalTo(ZGCConvertToPx(68));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
