//
//  EditRoleCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRoleCell.h"

@interface EditRoleCell ()

// viewModel
@property (nonatomic, readwrite, strong) EditRoleItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UILabel *valueLabel;
@property (nonatomic, readwrite, strong) UIImageView *selectIV;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;
@property (nonatomic, readwrite, strong) ZGButton *clickBtn;

@end

@implementation EditRoleCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"EditRoleCell";
    EditRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(EditRoleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleL.text = viewModel.title;
    RAC(self.valueLabel, text) = [RACObserve(viewModel, subTitle) takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self);
    [RACObserve(viewModel, shouldEdited) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.selectIV.hidden = !x.boolValue;
        self.clickBtn.enabled = x.boolValue;
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
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.font = kFont(16);
    valueLabel.textColor = kHexColor(@"#1C2B36");
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
    UIImageView *selectIV = [[UIImageView alloc] init];
    selectIV.image = ImageNamed(@"select_bottom");
    self.selectIV = selectIV;
    [self.contentView addSubview:selectIV];
    
    ZGButton *clickBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = UIColor.clearColor;
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.clickSub sendNext:[RACTuple tupleWithObjects:@(self.viewModel.type), sender, self.viewModel.subTitle, nil]];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ZGCConvertToPx(140));
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(ZGCConvertToPx(-15));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ZGCConvertToPx(13));
        make.height.mas_equalTo(ZGCConvertToPx(7));
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
