//
//  GoodInfoCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "GoodInfoCell.h"

@interface GoodInfoCell ()

@property (nonatomic, readwrite, strong) GoodInfoItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *temp1Label;
@property (nonatomic, readwrite, strong) UILabel *temp2Label;
@property (nonatomic, readwrite, strong) UILabel *temp3Label;
@property (nonatomic, readwrite, strong) UILabel *temp4Label;
@property (nonatomic, readwrite, strong) UILabel *temp5Label;
@property (nonatomic, readwrite, strong) UILabel *temp6Label;
@property (nonatomic, readwrite, strong) UILabel *temp7Label;
@property (nonatomic, readwrite, strong) UILabel *temp8Label;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) ZGButton *clickBtn;

@end

@implementation GoodInfoCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"GoodInfoCell";
    GoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(GoodInfoItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    RAC(self.temp1Label, text) = [RACObserve(viewModel, temp1) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp2Label, text) = [RACObserve(viewModel, temp2) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp3Label, text) = [RACObserve(viewModel, temp3) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp4Label, text) = [RACObserve(viewModel, temp4) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp5Label, text) = [RACObserve(viewModel, temp5) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp6Label, text) = [RACObserve(viewModel, temp6) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp7Label, text) = [RACObserve(viewModel, temp7) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.temp8Label, text) = [RACObserve(viewModel, temp8) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceLabel, text) = [[RACObserve(viewModel, price) takeUntil:self.rac_prepareForReuseSignal] map:^id(NSString *price) {
        @strongify(self);
        self.dividerLine.hidden = kStringIsEmpty(price);
        return price;
    }];
    
    [[RACObserve(viewModel, btnTitle) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *btnTitle) {
        @strongify(self);
        [self.clickBtn setTitle:btnTitle forState:UIControlStateNormal];
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
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = kHexColor(@"#F5F6FA");
}

- (void)_setupSubviews {
    UILabel *temp1Label = [[UILabel alloc] init];
    temp1Label.textColor = kHexColor(@"#020D2C");
    temp1Label.font = kBoldFont(13);
    self.temp1Label = temp1Label;
    [self.contentView addSubview:temp1Label];
    
    UILabel *temp2Label = [[UILabel alloc] init];
    temp2Label.textColor = kHexColor(@"#020D2C");
    temp2Label.font = kBoldFont(13);
    self.temp2Label = temp2Label;
    [self.contentView addSubview:temp2Label];
    
    UILabel *temp3Label = [[UILabel alloc] init];
    temp3Label.textColor = kHexColor(@"#020D2C");
    temp3Label.font = kBoldFont(13);
    self.temp3Label = temp3Label;
    [self.contentView addSubview:temp3Label];
    
    UILabel *temp4Label = [[UILabel alloc] init];
    temp4Label.textColor = kHexColor(@"#020D2C");
    temp4Label.font = kBoldFont(13);
    self.temp4Label = temp4Label;
    [self.contentView addSubview:temp4Label];
    
    UILabel *temp5Label = [[UILabel alloc] init];
    temp5Label.textColor = kHexColor(@"#020D2C");
    temp5Label.font = kBoldFont(13);
    self.temp5Label = temp5Label;
    [self.contentView addSubview:temp5Label];
    
    UILabel *temp6Label = [[UILabel alloc] init];
    temp6Label.textColor = kHexColor(@"#020D2C");
    temp6Label.font = kBoldFont(13);
    self.temp6Label = temp6Label;
    [self.contentView addSubview:temp6Label];
    
    UILabel *temp7Label = [[UILabel alloc] init];
    temp7Label.textColor = kHexColor(@"#020D2C");
    temp7Label.font = kBoldFont(13);
    self.temp7Label = temp7Label;
    [self.contentView addSubview:temp7Label];
    
    UILabel *temp8Label = [[UILabel alloc] init];
    temp8Label.textColor = kHexColor(@"#020D2C");
    temp8Label.font = kBoldFont(13);
    self.temp8Label = temp8Label;
    [self.contentView addSubview:temp8Label];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = kHexColor(@"#F85359");
    priceLabel.font = kBoldFont(16);
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    ZGButton *clickBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    clickBtn.layer.cornerRadius = ZGCConvertToPx(15);
    clickBtn.clipsToBounds = YES;
    [clickBtn setBackgroundColor:kHexColor(@"#3882FF")];
    [clickBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [clickBtn.titleLabel setFont:kBoldFont(13)];
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    @weakify(self);
    [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.operation) self.viewModel.operation();
    }];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = kHexColor(@"#CCCCCC");
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.temp1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(12.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp1Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp2Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp4Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp5Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp6Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp7Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(12.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ZGCConvertToPx(78));
        make.height.mas_equalTo(ZGCConvertToPx(30));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

@end
