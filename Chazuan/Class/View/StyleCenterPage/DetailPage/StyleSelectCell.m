//
//  StyleSelectCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleSelectCell.h"

@interface StyleSelectCell ()

@property (nonatomic, readwrite, strong) StyleSelectItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) UIImageView *selectImageV;

@end

@implementation StyleSelectCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"StyleSelectCell";
    StyleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(StyleSelectItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    RAC(self.titleLabel, text) = [RACObserve(viewModel, title) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(viewModel, name) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *name) {
        [self.selectBtn setTitle:name forState:UIControlStateNormal];
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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#020D2C");
    titleLabel.font = kFont(13);
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    ZGButton *selectBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:kFont(13)];
    selectBtn.layer.cornerRadius = 4;
    selectBtn.layer.borderColor = kHexColor(@"#dfe3ef").CGColor;
    selectBtn.layer.borderWidth = 1;
    selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, ZGCConvertToPx(10), 0, 0);
    self.selectBtn = selectBtn;
    [self.contentView addSubview:selectBtn];
    
    UIImageView *selectImageV = [[UIImageView alloc] init];
    selectImageV.image = ImageNamed(@"select_bottom");
    self.selectImageV = selectImageV;
    [selectBtn addSubview:selectImageV];
    
    @weakify(self);
    [[selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.selectBlock) self.viewModel.selectBlock(self, self.contentView.center);
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(13));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(33));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-45));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-2));
    }];
    
    [self.selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectBtn.mas_right).offset(ZGCConvertToPx(-20));
        make.width.height.mas_equalTo(ZGCConvertToPx(6));
        make.centerY.mas_equalTo(self.selectBtn);
    }];
}

@end
