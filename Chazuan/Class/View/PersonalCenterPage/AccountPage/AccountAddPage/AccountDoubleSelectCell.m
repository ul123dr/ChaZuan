//
//  AccountDoubleSelectCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountDoubleSelectCell.h"
#import "RightButton.h"

@interface AccountDoubleSelectCell ()

// viewModel
@property (nonatomic, readwrite, strong) AccountDoubleItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) RightButton *leftBtn;
@property (nonatomic, readwrite, strong) RightButton *rightBtn;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation AccountDoubleSelectCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"AccountDoubleSelectCell";
    AccountDoubleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(AccountDoubleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleL.text = viewModel.title;
    self.leftBtn.nameLabel.text = viewModel.leftStr;
    self.rightBtn.nameLabel.text = viewModel.rightStr;
    @weakify(self);
    [[RACObserve(viewModel, allowed) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.leftBtn.selected = x.boolValue;
        self.rightBtn.selected = !x.boolValue;
    }];
    [RACObserve(viewModel, shouldEdited) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.leftBtn.enabled = x.boolValue;
        self.rightBtn.enabled = x.boolValue;
    }];
    [RACObserve(viewModel, show) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.leftBtn.hidden = !x.boolValue;
        self.rightBtn.hidden = !x.boolValue;
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
    
    RightButton *leftBtn = [RightButton buttonWithType:UIButtonTypeCustom];
    leftBtn.nameLabel.textColor = kHexColor(@"#1C2B36");
    leftBtn.nameLabel.font = kFont(16);
    self.leftBtn = leftBtn;
    [self.contentView addSubview:leftBtn];
    
    RightButton *rightBtn = [RightButton buttonWithType:UIButtonTypeCustom];
    rightBtn.nameLabel.textColor = kHexColor(@"#1C2B36");
    rightBtn.nameLabel.font = kFont(16);
    self.rightBtn = rightBtn;
    [self.contentView addSubview:rightBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (sender.selected) return;
        sender.selected = YES;
        rightBtn.selected = NO;
        self.viewModel.allowed = YES;
    }];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (sender.selected) return;
        sender.selected = YES;
        leftBtn.selected = NO;
        self.viewModel.allowed = NO;
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ZGCConvertToPx(140));
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.leftBtn);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
