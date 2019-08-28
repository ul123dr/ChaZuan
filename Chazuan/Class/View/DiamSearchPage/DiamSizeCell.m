
//
//  DiamSizeCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSizeCell.h"

@interface DiamSizeCell ()

/// viewModel
@property (nonatomic, readwrite, strong) SizeItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) UILabel *nameLabel;
@property (nonatomic, readwrite, strong) UITextField *textField1;
@property (nonatomic, readwrite, strong) UILabel *sepLabel;
@property (nonatomic, readwrite, strong) UITextField *textField2;
@property (nonatomic, readwrite, strong) ZGButton *sizeBtn;


@end

@implementation DiamSizeCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DiamSizeCell";
    DiamSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(SizeItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [[RACObserve(viewModel, btnTitle) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *btnTitle) {
        @strongify(self);
        [self.sizeBtn setTitle:btnTitle forState:UIControlStateNormal];
    }];
    self.textField1.text = viewModel.sizeMin;
    self.textField2.text = viewModel.sizeMax;
    RACChannelTo(viewModel, sizeMin) = self.textField1.rac_newTextChannel;
    RACChannelTo(viewModel, sizeMax) = self.textField2.rac_newTextChannel;
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
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kHexColor(@"#1C2B36");
    nameLabel.font = kFont(15);
    nameLabel.text = @"克拉";
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UITextField *textField1 = [[UITextField alloc] init];
    textField1.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField1.layer.borderWidth = 1;
    textField1.layer.cornerRadius = 2;
    textField1.font = kFont(15);
    textField1.textColor = kHexColor(@"#333333");
    textField1.textAlignment = NSTextAlignmentCenter;
    textField1.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField1 = textField1;
    [self.contentView addSubview:textField1];
    
    UILabel *sepLabel = [[UILabel alloc] init];
    sepLabel.textColor = kHexColor(@"#1C2B36");
    sepLabel.font = kBoldFont(15);
    sepLabel.text = @"~";
    sepLabel.textAlignment = NSTextAlignmentCenter;
    self.sepLabel = sepLabel;
    [self.contentView addSubview:sepLabel];
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField2.layer.borderWidth = 1;
    textField2.layer.cornerRadius = 2;
    textField2.font = kFont(15);
    textField2.textColor = kHexColor(@"#333333");
    textField2.textAlignment = NSTextAlignmentCenter;
    textField2.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField2 = textField2;
    [self.contentView addSubview:textField2];
    
    ZGButton *sizeBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    sizeBtn.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    sizeBtn.layer.borderWidth = 1;
    sizeBtn.layer.cornerRadius = 2;
    [sizeBtn.titleLabel setFont:kFont(15)];
    [sizeBtn setTitleColor:kHexColor(@"#333333") forState:UIControlStateNormal];
    self.sizeBtn = sizeBtn;
    [self.contentView addSubview:sizeBtn];
    
    @weakify(self);
    [[sizeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.sizeSub sendNext:sender];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
    }];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.nameLabel).multipliedBy(1.1);
    }];
    [self.sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.left.mas_equalTo(self.textField1.mas_right);
        make.width.mas_equalTo(self.textField1).multipliedBy(1.0/3);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.left.mas_equalTo(self.sepLabel.mas_right);
        make.width.mas_equalTo(self.textField1);
    }];
    [self.sizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        make.left.mas_equalTo(self.textField2.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.textField1);
    }];
}

@end
