//
//  EditRateCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRateCell.h"

@interface EditRateCell ()

// viewModel
@property (nonatomic, readwrite, strong) EditRateItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UITextField *textField;
@property (nonatomic, readwrite, strong) UILabel *valueLabel;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation EditRateCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"EditRateCell";
    EditRateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(EditRateItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    self.titleL.text = viewModel.title;
    self.textField.placeholder = viewModel.placeholder;
    self.textField.text = viewModel.value;
    self.valueLabel.text = viewModel.value;
    [[RACObserve(viewModel, isText) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *isText) {
        @strongify(self);
        self.valueLabel.hidden = !isText.boolValue;
        self.textField.hidden = isText.boolValue;
    }];
    RACChannelTo(viewModel, value) = self.textField.rac_newTextChannel;
    [RACObserve(viewModel, shouldEdited) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.textField.enabled = x.boolValue;
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
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kFont(15);
    titleL.textColor = kHexColor(@"#98A2A9");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = kHexColor(@"#1C2B36");
    textField.font = kFont(15);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField = textField;
    [self.contentView addSubview:textField];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = kHexColor(@"#1C2B36");
    valueLabel.font = kFont(15);
    valueLabel.numberOfLines = 0;
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
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
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(14.5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-14.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
