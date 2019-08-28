//
//  DiamSuspendCollectionViewCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSuspendCollectionViewCell.h"

@interface DiamSuspendCollectionViewCell ()

@property (nonatomic, readwrite, strong) DiamSearchResultItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *selectLabel;
@property (nonatomic, readwrite, strong) UILabel *sizeLabel;
@property (nonatomic, readwrite, strong) UILabel *colorLabel;
@property (nonatomic, readwrite, strong) UILabel *clarityLabel;
@property (nonatomic, readwrite, strong) UILabel *cutLabel;
@property (nonatomic, readwrite, strong) UILabel *polishLabel;
@property (nonatomic, readwrite, strong) UILabel *symLabel;
@property (nonatomic, readwrite, strong) UILabel *flourLabel;
@property (nonatomic, readwrite, strong) ZGButton *discBtn;
@property (nonatomic, readwrite, strong) ZGButton *moneyBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine1;
@property (nonatomic, readwrite, strong) UIView *dividerLine2;
@property (nonatomic, readwrite, strong) UIView *dividerLine3;
@property (nonatomic, readwrite, strong) UIView *dividerLine4;
@property (nonatomic, readwrite, strong) UIView *dividerLine5;
@property (nonatomic, readwrite, strong) UIView *dividerLine6;
@property (nonatomic, readwrite, strong) UIView *dividerLine7;
@property (nonatomic, readwrite, strong) UIView *dividerLine8;
@property (nonatomic, readwrite, strong) UIView *dividerLine9;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation DiamSuspendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraints];
    }
    return self;
}

- (void)bindViewModel:(DiamSearchResultItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.discBtn.selected = viewModel.discType;
    self.moneyBtn.selected = viewModel.moneyType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)_setup {
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.clipsToBounds = YES;
}

- (void)_setupSubviews {
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.textColor = kHexColor(@"#1C2B36");
    selectLabel.font = kFont(12);
    selectLabel.text = @"勾选";
    self.selectLabel = selectLabel;
    [self.contentView addSubview:selectLabel];
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    sizeLabel.textColor = kHexColor(@"#1C2B36");
    sizeLabel.font = kFont(12);
    sizeLabel.text = @"克拉";
    self.sizeLabel = sizeLabel;
    [self.contentView addSubview:sizeLabel];
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.textAlignment = NSTextAlignmentCenter;
    colorLabel.textColor = kHexColor(@"#1C2B36");
    colorLabel.font = kFont(12);
    colorLabel.text = @"颜色";
    self.colorLabel = colorLabel;
    [self.contentView addSubview:colorLabel];
    
    UILabel *clarityLabel = [[UILabel alloc] init];
    clarityLabel.textAlignment = NSTextAlignmentCenter;
    clarityLabel.textColor = kHexColor(@"#1C2B36");
    clarityLabel.font = kFont(12);
    clarityLabel.text = @"净度";
    self.clarityLabel = clarityLabel;
    [self.contentView addSubview:clarityLabel];
    
    UILabel *cutLabel = [[UILabel alloc] init];
    cutLabel.textAlignment = NSTextAlignmentCenter;
    cutLabel.textColor = kHexColor(@"#1C2B36");
    cutLabel.font = kFont(12);
    cutLabel.text = @"切工";
    self.cutLabel = cutLabel;
    [self.contentView addSubview:cutLabel];
    
    UILabel *polishLabel = [[UILabel alloc] init];
    polishLabel.textAlignment = NSTextAlignmentCenter;
    polishLabel.textColor = kHexColor(@"#1C2B36");
    polishLabel.font = kFont(12);
    polishLabel.text = @"抛光";
    self.polishLabel = polishLabel;
    [self.contentView addSubview:polishLabel];
    
    UILabel *symLabel = [[UILabel alloc] init];
    symLabel.textAlignment = NSTextAlignmentCenter;
    symLabel.textColor = kHexColor(@"#1C2B36");
    symLabel.font = kFont(12);
    symLabel.text = @"对称";
    self.symLabel = symLabel;
    [self.contentView addSubview:symLabel];
    
    UILabel *flourLabel = [[UILabel alloc] init];
    flourLabel.textAlignment = NSTextAlignmentCenter;
    flourLabel.textColor = kHexColor(@"#1C2B36");
    flourLabel.font = kFont(12);
    flourLabel.text = @"荧光";
    self.flourLabel = flourLabel;
    [self.contentView addSubview:flourLabel];
    
    if ([SingleInstance boolForKey:DiscShowKey]) {
        ZGButton *discBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [discBtn setTitle:@"折扣" forState:UIControlStateNormal];
        [discBtn.titleLabel setFont:kFont(12)];
        [discBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [discBtn setImage:ImageNamed(@"diamResult_top_blue") forState:UIControlStateNormal];
        [discBtn setImage:ImageNamed(@"diamResult_bottom_blue") forState:UIControlStateSelected];
        CGFloat discWidth = sizeOfString(@"折扣", kFont(12), 100).width;
        [discBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10.f, 0, 5.f)];
        [discBtn setImageEdgeInsets:UIEdgeInsetsMake(0, discWidth, 0, -discWidth)];
        self.discBtn = discBtn;
        [self.contentView addSubview:discBtn];
    }
    ZGButton *moneyBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    NSInteger userLevel = [HTTPService sharedInstance].currentUser.userType;
    if ([SingleInstance boolForKey:RapBuyShowKey] && (userLevel == 2 || userLevel == 99)) {
        [moneyBtn setTitle:@"购美金/粒" forState:UIControlStateNormal];
    } else {
        [moneyBtn setTitle:@"人民币/粒" forState:UIControlStateNormal];
    }
    [moneyBtn.titleLabel setFont:kFont(12)];
    [moneyBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [moneyBtn setImage:ImageNamed(@"diamResult_top_blue") forState:UIControlStateNormal];
    [moneyBtn setImage:ImageNamed(@"diamResult_bottom_blue") forState:UIControlStateSelected];
    CGFloat moneyWidth = sizeOfString(moneyBtn.titleLabel.text, kFont(12), 150).width;
    [moneyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10.f, 0, 5.f)];
    [moneyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, moneyWidth, 0, -moneyWidth)];
    self.moneyBtn = moneyBtn;
    [self.contentView addSubview:moneyBtn];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = COLOR_LINE;
    self.dividerLine1 = dividerLine1;
    [self.contentView addSubview:dividerLine1];
    UIView *dividerLine2 = [[UIView alloc] init];
    dividerLine2.backgroundColor = COLOR_LINE;
    self.dividerLine2 = dividerLine2;
    [self.contentView addSubview:dividerLine2];
    UIView *dividerLine3 = [[UIView alloc] init];
    dividerLine3.backgroundColor = COLOR_LINE;
    self.dividerLine3 = dividerLine3;
    [self.contentView addSubview:dividerLine3];
    UIView *dividerLine4 = [[UIView alloc] init];
    dividerLine4.backgroundColor = COLOR_LINE;
    self.dividerLine4 = dividerLine4;
    [self.contentView addSubview:dividerLine4];
    UIView *dividerLine5 = [[UIView alloc] init];
    dividerLine5.backgroundColor = COLOR_LINE;
    self.dividerLine5 = dividerLine5;
    [self.contentView addSubview:dividerLine5];
    UIView *dividerLine6 = [[UIView alloc] init];
    dividerLine6.backgroundColor = COLOR_LINE;
    self.dividerLine6 = dividerLine6;
    [self.contentView addSubview:dividerLine6];
    UIView *dividerLine7 = [[UIView alloc] init];
    dividerLine7.backgroundColor = COLOR_LINE;
    self.dividerLine7 = dividerLine7;
    [self.contentView addSubview:dividerLine7];
    if ([SingleInstance boolForKey:DiscShowKey]) {
        UIView *dividerLine8 = [[UIView alloc] init];
        dividerLine8.backgroundColor = COLOR_LINE;
        self.dividerLine8 = dividerLine8;
        [self.contentView addSubview:dividerLine8];
    }
    UIView *dividerLine9 = [[UIView alloc] init];
    dividerLine9.backgroundColor = COLOR_LINE;
    self.dividerLine9 = dividerLine9;
    [self.contentView addSubview:dividerLine9];
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[self.discBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        [self.viewModel.discSub sendNext:@(sender.selected)];
    }];
    [[self.moneyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        [self.viewModel.moneySub sendNext:@(sender.selected)];
    }];
}

- (void)_setupSubviewsConstraints {
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.08);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.selectLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.clarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.colorLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.cutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.clarityLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.polishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.cutLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.symLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.polishLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.flourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.symLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    if ([SingleInstance boolForKey:DiscShowKey]) {
        [self.discBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.flourLabel.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.11);
        }];
        [self.moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.discBtn.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
    } else {
        [self.moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.flourLabel.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
    }
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.selectLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.sizeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.colorLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.clarityLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.cutLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.polishLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.symLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    if ([SingleInstance boolForKey:DiscShowKey]) {
        [self.dividerLine8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
        [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.discBtn.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    } else {
        [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    }
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

@end
