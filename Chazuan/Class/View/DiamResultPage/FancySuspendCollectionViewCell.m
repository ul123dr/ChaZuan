//
//  FancySuspendCollectionViewCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancySuspendCollectionViewCell.h"

@interface FancySuspendCollectionViewCell ()

@property (nonatomic, readwrite, strong) DiamSearchResultItemViewModel *viewModel;

@property (nonatomic, readwrite, assign) BOOL isRap;
@property (nonatomic, readwrite, assign) BOOL fancyRapShow;

@property (nonatomic, readwrite, strong) UILabel *selectLabel;
@property (nonatomic, readwrite, strong) UILabel *rapLabel;
@property (nonatomic, readwrite, strong) UILabel *fancyRapLabel;
@property (nonatomic, readwrite, strong) ZGButton *moneyBtn;
@property (nonatomic, readwrite, strong) UILabel *shapeLabel;
@property (nonatomic, readwrite, strong) UILabel *sizeLabel;
@property (nonatomic, readwrite, strong) UILabel *colorLabel;
@property (nonatomic, readwrite, strong) UILabel *clarityLabel;
@property (nonatomic, readwrite, strong) UILabel *polishLabel;
@property (nonatomic, readwrite, strong) UILabel *symLabel;
@property (nonatomic, readwrite, strong) UILabel *flourLabel;
@property (nonatomic, readwrite, strong) UILabel *certLabel;
@property (nonatomic, readwrite, strong) UIView *dividerLine1;
@property (nonatomic, readwrite, strong) UIView *dividerLine2;
@property (nonatomic, readwrite, strong) UIView *dividerLine3;
@property (nonatomic, readwrite, strong) UIView *dividerLine4;
@property (nonatomic, readwrite, strong) UIView *dividerLine5;
@property (nonatomic, readwrite, strong) UIView *dividerLine6;
@property (nonatomic, readwrite, strong) UIView *dividerLine7;
@property (nonatomic, readwrite, strong) UIView *dividerLine8;
@property (nonatomic, readwrite, strong) UIView *dividerLine9;
@property (nonatomic, readwrite, strong) UIView *dividerLine10;
@property (nonatomic, readwrite, strong) UIView *dividerLine11;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation FancySuspendCollectionViewCell

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
    self.moneyBtn.selected = viewModel.moneyType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)_setup {
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.clipsToBounds = YES;
    self.isRap = [SingleInstance boolForKey:RapIdShowKey];
    self.fancyRapShow = [SingleInstance boolForKey:FancyRapKey];
}

- (void)_setupSubviews {
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.textColor = kHexColor(@"#1C2B36");
    selectLabel.font = kFont(12);
    selectLabel.text = @"勾选";
    self.selectLabel = selectLabel;
    [self.contentView addSubview:selectLabel];
    
    UILabel *rapLabel = [[UILabel alloc] init];
    rapLabel.textAlignment = NSTextAlignmentCenter;
    rapLabel.textColor = kHexColor(@"#1C2B36");
    rapLabel.font = kFont(12);
    rapLabel.text = self.isRap?@"供应商":@"图片";
    self.rapLabel = rapLabel;
    [self.contentView addSubview:rapLabel];
    
    if (self.fancyRapShow) {
        UILabel *fancyRapLabel = [[UILabel alloc] init];
        fancyRapLabel.textAlignment = NSTextAlignmentCenter;
        fancyRapLabel.textColor = kHexColor(@"#1C2B36");
        fancyRapLabel.font = kFont(12);
        fancyRapLabel.text = @"$/Ct";
        self.fancyRapLabel = fancyRapLabel;
        [self.contentView addSubview:fancyRapLabel];
    }
    
    ZGButton *moneyBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [moneyBtn setTitle:@"人民币/粒" forState:UIControlStateNormal];
    [moneyBtn.titleLabel setFont:kFont(12)];
    [moneyBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [moneyBtn setImage:ImageNamed(@"diamResult_top_blue") forState:UIControlStateNormal];
    [moneyBtn setImage:ImageNamed(@"diamResult_bottom_blue") forState:UIControlStateSelected];
    CGFloat moneyWidth = sizeOfString(moneyBtn.titleLabel.text, kFont(12), 150).width;
    [moneyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10.f, 0, 5.f)];
    [moneyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, moneyWidth, 0, -moneyWidth)];
    self.moneyBtn = moneyBtn;
    [self.contentView addSubview:moneyBtn];
    
    UILabel *shapeLabel = [[UILabel alloc] init];
    shapeLabel.textAlignment = NSTextAlignmentCenter;
    shapeLabel.textColor = kHexColor(@"#1C2B36");
    shapeLabel.font = kFont(12);
    shapeLabel.text = @"形状";
    self.shapeLabel = shapeLabel;
    [self.contentView addSubview:shapeLabel];
    
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
    colorLabel.text = @"规格";
    self.colorLabel = colorLabel;
    [self.contentView addSubview:colorLabel];
    
    UILabel *clarityLabel = [[UILabel alloc] init];
    clarityLabel.textAlignment = NSTextAlignmentCenter;
    clarityLabel.textColor = kHexColor(@"#1C2B36");
    clarityLabel.font = kFont(12);
    clarityLabel.text = @"净度";
    self.clarityLabel = clarityLabel;
    [self.contentView addSubview:clarityLabel];
    
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
    
    UILabel *certLabel = [[UILabel alloc] init];
    certLabel.textAlignment = NSTextAlignmentCenter;
    certLabel.textColor = kHexColor(@"#1C2B36");
    certLabel.font = kFont(12);
    certLabel.text = @"证书";
    self.certLabel = certLabel;
    [self.contentView addSubview:certLabel];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = COLOR_LINE;
    self.dividerLine1 = dividerLine1;
    [self.contentView addSubview:dividerLine1];
    UIView *dividerLine2 = [[UIView alloc] init];
    dividerLine2.backgroundColor = COLOR_LINE;
    self.dividerLine2 = dividerLine2;
    [self.contentView addSubview:dividerLine2];
    if (self.fancyRapShow) {
        UIView *dividerLine3 = [[UIView alloc] init];
        dividerLine3.backgroundColor = COLOR_LINE;
        self.dividerLine3 = dividerLine3;
        [self.contentView addSubview:dividerLine3];
    }
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
    UIView *dividerLine8 = [[UIView alloc] init];
    dividerLine8.backgroundColor = COLOR_LINE;
    self.dividerLine8 = dividerLine8;
    [self.contentView addSubview:dividerLine8];
    UIView *dividerLine9 = [[UIView alloc] init];
    dividerLine9.backgroundColor = COLOR_LINE;
    self.dividerLine9 = dividerLine9;
    [self.contentView addSubview:dividerLine9];
    UIView *dividerLine10 = [[UIView alloc] init];
    dividerLine10.backgroundColor = COLOR_LINE;
    self.dividerLine10 = dividerLine10;
    [self.contentView addSubview:dividerLine10];
    UIView *dividerLine11 = [[UIView alloc] init];
    dividerLine11.backgroundColor = COLOR_LINE;
    self.dividerLine11 = dividerLine11;
    [self.contentView addSubview:dividerLine11];
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
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
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.05);
    }];
    [self.rapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.selectLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    if (self.fancyRapShow) {
        [self.fancyRapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.rapLabel.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.1);
        }];
    }
    [self.moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        if (self.fancyRapShow) make.left.mas_equalTo(self.fancyRapLabel.mas_right);
        else make.left.mas_equalTo(self.rapLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.12);
    }];
    [self.shapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.moneyBtn.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.shapeLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.20);
    }];
    [self.clarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.colorLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.polishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.clarityLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.symLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.polishLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.flourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.symLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.flourLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.selectLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.rapLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    if (self.fancyRapShow) {
        [self.dividerLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.fancyRapLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    }
    [self.dividerLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.moneyBtn.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.shapeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.sizeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.colorLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.clarityLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.polishLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.symLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

@end
