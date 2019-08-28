//
//  FancyCollectionViewCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyCollectionViewCell.h"
#import "FancyInfoView.h"

@interface FancyCollectionViewCell ()

/// viewModel
@property (nonatomic, readwrite, strong) DiamSearchResultItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) ZGButton *selectClearBtn;
@property (nonatomic, readwrite, strong) UILabel *statusLabel;
@property (nonatomic, readwrite, strong) ZGButton *rapBtn;
@property (nonatomic, readwrite, strong) UIImageView *imgIV;
@property (nonatomic, readwrite, strong) UILabel *fancyRapLabel;
@property (nonatomic, readwrite, strong) UILabel *moneyLabel;
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
@property (nonatomic, readwrite, strong) UIView *dividerLineH;

@property (nonatomic, readwrite, strong) ZGButton *clickBtn;

@property (nonatomic, readwrite, strong) FancyInfoView *infoView;

@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation FancyCollectionViewCell

#pragma mark - Public Method
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)bindViewModel:(DiamSearchResultItemViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [RACObserve(viewModel, list) subscribeNext:^(DiamResultList *list) {
        @strongify(self);
        if ([SingleInstance boolForKey:RapIdShowKey]) [self.rapBtn setTitle:list.detail forState:UIControlStateNormal];
        else [self.rapBtn setTitle:@"-" forState:UIControlStateNormal];
        self.imgIV.hidden = ![SingleInstance boolForKey:ImgShowKey] || kStringIsEmpty(list.daylight);
        if ([SingleInstance boolForKey:FancyRapKey]) self.fancyRapLabel.text = [NSString stringWithFormat:@"%.2f", list.rap.floatValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", round(list.rate.floatValue * list.dollarRate.floatValue)];
        self.shapeLabel.text = formatString(list.shape);
        self.sizeLabel.text = [NSString stringWithFormat:@"%.2f", list.dSize.floatValue];
        self.colorLabel.text = formatString(list.color);
        self.clarityLabel.text = formatString(list.clarity);
        self.polishLabel.text = formatString(list.polish);
        self.symLabel.text = formatString(list.sym);
        self.flourLabel.text = formatString(list.flour);
        self.certLabel.text = formatString(list.cert);
        
//        self.infoView.supplyList = viewModel.supplyList;
        self.infoView.rate = list.dollarRate;
        self.infoView.list = list;
    }];
    [RACObserve(viewModel, selected) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.selectBtn.selected = x.boolValue;
        self.selectClearBtn.selected = x.boolValue;
    }];
    [RACObserve(viewModel, opened) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.rapBtn.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.fancyRapLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.moneyLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.shapeLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.sizeLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.colorLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.clarityLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.polishLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.symLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.flourLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.certLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        
        self.clickBtn.selected = x.boolValue;
    }];

    [[RACObserve(self.infoView, addNum) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        viewModel.list.num = x;
    }];

    [[RACObserve(self.infoView, rate) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        viewModel.list.dollarRate = x;
    }];
    self.infoView.index = self.viewModel.index;
    self.infoView.clickSub = viewModel.clickSub;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - 辅助方法
- (void)_setup {
    self.contentView.clipsToBounds = YES;
}

- (void)_setupSubviews {
    ZGButton *selectBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = kHexColor(@"#d3dadc");
    [selectBtn setImage:ImageNamed(@"diamResult_active") forState:UIControlStateSelected];
    self.selectBtn = selectBtn;
    [self.contentView addSubview:selectBtn];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = kFont(12);
    self.statusLabel = statusLabel;
    [self.contentView addSubview:statusLabel];
    
    ZGButton *selectClearBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    selectClearBtn.backgroundColor = UIColor.clearColor;
    self.selectClearBtn = selectClearBtn;
    [self.contentView addSubview:selectClearBtn];
    
    ZGButton *rapBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rapBtn.titleLabel setFont:kFont(12)];
    [rapBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    self.rapBtn = rapBtn;
    [self.contentView addSubview:rapBtn];
    UIImageView *imgIV = [[UIImageView alloc] init];
    imgIV.image = ImageNamed(@"diamResult_img");
    self.imgIV = imgIV;
    [rapBtn addSubview:imgIV];
    
    if ([SingleInstance boolForKey:FancyRapKey]) {
        UILabel *fancyRapLabel = [[UILabel alloc] init];
        fancyRapLabel.textAlignment = NSTextAlignmentCenter;
        fancyRapLabel.textColor = kHexColor(@"#1C2B36");
        fancyRapLabel.font = kFont(12);
        self.fancyRapLabel = fancyRapLabel;
        [self.contentView addSubview:fancyRapLabel];
    }
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = kHexColor(@"#1C2B36");
    moneyLabel.font = kFont(12);
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    self.moneyLabel = moneyLabel;
    [self.contentView addSubview:moneyLabel];
    
    UILabel *shapeLabel = [[UILabel alloc] init];
    shapeLabel.textAlignment = NSTextAlignmentCenter;
    shapeLabel.textColor = kHexColor(@"#1C2B36");
    shapeLabel.font = kFont(12);
    self.shapeLabel = shapeLabel;
    [self.contentView addSubview:shapeLabel];
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    sizeLabel.textColor = kHexColor(@"#1C2B36");
    sizeLabel.font = kFont(12);
    self.sizeLabel = sizeLabel;
    [self.contentView addSubview:sizeLabel];
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.textAlignment = NSTextAlignmentCenter;
    colorLabel.numberOfLines = 2;
    colorLabel.textColor = kHexColor(@"#1C2B36");
    colorLabel.font = kFont(12);
    self.colorLabel = colorLabel;
    [self.contentView addSubview:colorLabel];
    
    UILabel *clarityLabel = [[UILabel alloc] init];
    clarityLabel.textAlignment = NSTextAlignmentCenter;
    clarityLabel.textColor = kHexColor(@"#1C2B36");
    clarityLabel.font = kFont(12);
    self.clarityLabel = clarityLabel;
    [self.contentView addSubview:clarityLabel];
    
    UILabel *polishLabel = [[UILabel alloc] init];
    polishLabel.textAlignment = NSTextAlignmentCenter;
    polishLabel.textColor = kHexColor(@"#1C2B36");
    polishLabel.font = kFont(12);
    self.polishLabel = polishLabel;
    [self.contentView addSubview:polishLabel];
    
    UILabel *symLabel = [[UILabel alloc] init];
    symLabel.textAlignment = NSTextAlignmentCenter;
    symLabel.textColor = kHexColor(@"#1C2B36");
    symLabel.font = kFont(12);
    self.symLabel = symLabel;
    [self.contentView addSubview:symLabel];
    
    UILabel *flourLabel = [[UILabel alloc] init];
    flourLabel.textAlignment = NSTextAlignmentCenter;
    flourLabel.textColor = kHexColor(@"#1C2B36");
    flourLabel.font = kFont(12);
    self.flourLabel = flourLabel;
    [self.contentView addSubview:flourLabel];
    
    UILabel *certLabel = [[UILabel alloc] init];
    certLabel.textAlignment = NSTextAlignmentCenter;
    certLabel.textColor = kHexColor(@"#1C2B36");
    certLabel.font = kFont(12);
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
    if ([SingleInstance boolForKey:FancyRapKey]) {
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
    UIView *dividerLineH = [[UIView alloc] init];
    dividerLineH.backgroundColor = COLOR_LINE;
    self.dividerLineH = dividerLineH;
    [self.contentView addSubview:dividerLineH];
    
    ZGButton *clickBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = UIColor.clearColor;
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    @weakify(self);
    [[selectClearBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        selectBtn.selected = sender.selected;
        if (self.viewModel.selectOperation) self.viewModel.selectOperation(sender.selected);
    }];
    [[rapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.detailSub sendNext:@(self.viewModel.index)];
    }];
    [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        if (self.viewModel.clickOperation) self.viewModel.clickOperation(sender.selected);
    }];
    
    FancyInfoView *infoView = [[FancyInfoView alloc] init];
    self.infoView = infoView;
    [self.contentView addSubview:infoView];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.02);
        make.height.mas_equalTo(self.selectBtn.mas_width);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(11.25));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectBtn.mas_bottom);
        make.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.05);
        make.height.mas_equalTo(ZGCConvertToPx(16));
    }];
    [self.selectClearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.08);
        make.height.mas_equalTo(self.selectBtn.mas_width);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView);
    }];
    [self.rapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.statusLabel.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(40));
    }];
    [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rapBtn).offset(ZGCConvertToPx(15));
        make.top.mas_equalTo(self.rapBtn).offset(ZGCConvertToPx(3));
        make.width.height.mas_equalTo(ZGCConvertToPx(14));
    }];
    if ([SingleInstance boolForKey:FancyRapKey]) {
        [self.fancyRapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.rapBtn.mas_right);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.1);
            make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        }];
    }
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        if ([SingleInstance boolForKey:FancyRapKey]) make.left.mas_equalTo(self.fancyRapLabel.mas_right);
        else make.left.mas_equalTo(self.rapBtn.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.12);
    }];
    [self.shapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.moneyLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.shapeLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.20);
    }];
    [self.clarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.colorLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.polishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.clarityLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.symLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.polishLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.flourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.symLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
    }];
    [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rapBtn);
        make.left.mas_equalTo(self.flourLabel.mas_right);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.06);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.statusLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.left.mas_equalTo(self.rapBtn.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    if ([SingleInstance boolForKey:FancyRapKey]) {
        [self.dividerLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.fancyRapLabel.mas_bottom);
            make.left.mas_equalTo(self.fancyRapLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    }
    [self.dividerLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.moneyLabel.mas_bottom);
        make.left.mas_equalTo(self.moneyLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.shapeLabel.mas_bottom);
        make.left.mas_equalTo(self.shapeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.sizeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.colorLabel.mas_bottom);
        make.left.mas_equalTo(self.colorLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.clarityLabel.mas_bottom);
        make.left.mas_equalTo(self.clarityLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.polishLabel.mas_bottom);
        make.left.mas_equalTo(self.polishLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.symLabel.mas_bottom);
        make.left.mas_equalTo(self.symLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.flourLabel.mas_bottom);
        make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    
    [self.dividerLineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rapBtn.mas_bottom);
        make.left.mas_equalTo(self.dividerLine1.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.rapBtn.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.dividerLineH);
    }];
    
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLineH.mas_bottom);
        make.left.mas_equalTo(self.dividerLine1.mas_right);
        make.right.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}


@end
