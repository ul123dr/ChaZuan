//
//  DiamCollectionViewCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamCollectionViewCell.h"
#import "DiamInfoView.h"

@interface DiamCollectionViewCell ()

/// viewModel
@property (nonatomic, readwrite, strong) DiamSearchResultItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) ZGButton *selectClearBtn;
@property (nonatomic, readwrite, strong) UILabel *statusLabel;
@property (nonatomic, readwrite, strong) UILabel *sizeLabel;
@property (nonatomic, readwrite, strong) UIImageView *shapeIV;
@property (nonatomic, readwrite, strong) UILabel *colorLabel;
@property (nonatomic, readwrite, strong) UIImageView *colorIV;
@property (nonatomic, readwrite, strong) UILabel *clarityLabel;
@property (nonatomic, readwrite, strong) UILabel *cutLabel;
@property (nonatomic, readwrite, strong) UILabel *polishLabel;
@property (nonatomic, readwrite, strong) UILabel *symLabel;
@property (nonatomic, readwrite, strong) UILabel *flourLabel;
@property (nonatomic, readwrite, strong) UILabel *discLabel;
@property (nonatomic, readwrite, strong) UILabel *moneyLabel;

@property (nonatomic, readwrite, strong) UIView *dividerLine1;
@property (nonatomic, readwrite, strong) UIView *dividerLine2;
@property (nonatomic, readwrite, strong) UIView *dividerLine3;
@property (nonatomic, readwrite, strong) UIView *dividerLine4;
@property (nonatomic, readwrite, strong) UIView *dividerLine5;
@property (nonatomic, readwrite, strong) UIView *dividerLine6;
@property (nonatomic, readwrite, strong) UIView *dividerLine7;
@property (nonatomic, readwrite, strong) UIView *dividerLine8;
@property (nonatomic, readwrite, strong) UIView *dividerLine9;
@property (nonatomic, readwrite, strong) UIView *dividerLineH;

@property (nonatomic, readwrite, strong) ZGButton *clickBtn;

@property (nonatomic, readwrite, strong) DiamInfoView *infoView;

@property (nonatomic, readwrite, strong) UIView *dividerLine;
@end

@implementation DiamCollectionViewCell

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
    NSArray *statusArr = @[@"订货",@"在库",@"预售",@"借出",@"锁定",@"现货"];
    @weakify(self);
    [RACObserve(viewModel, list) subscribeNext:^(DiamResultList *list) {
        @strongify(self);
        NSInteger status = list.sysStatus.integerValue;
        self.statusLabel.text = status<statusArr.count?statusArr[status]:@"锁定";
        self.statusLabel.textColor = status==4?kHexColor(@"#f85359"):kHexColor(@"#3882ff");
        self.sizeLabel.text = [NSString stringWithFormat:@"%.2f", list.dSize.floatValue];
        self.shapeIV.image = ImageNamed((kStringIsNotEmpty(list.shape) && [list.shape isEqualToString:@"圆形"])?@"yuan_icon.png":@"yi_icon.png");
        self.colorLabel.text = formatString(list.color);
        if (list.browness && ([list.browness containsString:@"B"] || [list.browness containsString:@"有"] || [list.browness containsString:@"带"])) {
            self.colorIV.image = ImageNamed(@"ka_icon.png");
        } else if (list.milky && ([list.milky containsString:@"M"] || [list.milky containsString:@"有"] || [list.milky containsString:@"带"])) {
            self.colorIV.image = ImageNamed(@"nai_icon.png");
        } else if (list.green && [list.green containsString:@"G"]) {
            self.colorIV.image = ImageNamed(@"lv_icon.png");
        } else {
            self.colorIV.image = nil;
        }
        self.clarityLabel.text = formatString(list.clarity);
        self.cutLabel.text = formatString(list.cut);
        self.polishLabel.text = formatString(list.polish);
        self.symLabel.text = formatString(list.sym);
        self.flourLabel.text = formatString(list.flour);
        if ([SingleInstance boolForKey:DiscShowKey])
            self.discLabel.text = [NSString stringWithFormat:@"%.2f", 0-list.disc.floatValue];
        NSInteger userLevel = [HTTPService sharedInstance].currentUser.userType;
        if ([SingleInstance boolForKey:RapBuyShowKey] && (userLevel == 2 || userLevel == 99)) {
            self.moneyLabel.text = [NSString stringWithFormat:@"$%.2f", round(list.rate.doubleValue)];
        } else {
            self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", round(list.rate.floatValue * list.dollarRate.floatValue)];
        }
        self.infoView.supplyList = viewModel.supplyList;
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
        self.sizeLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.colorLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.clarityLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.cutLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.polishLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.symLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.flourLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.discLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
        self.moneyLabel.backgroundColor = x.boolValue?kHexColor(@"#bbc2c4"):UIColor.whiteColor;
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
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    sizeLabel.textColor = kHexColor(@"#1C2B36");
    sizeLabel.font = kFont(12);
    self.sizeLabel = sizeLabel;
    [self.contentView addSubview:sizeLabel];
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UILabel *cutLabel = [[UILabel alloc] init];
    cutLabel.textAlignment = NSTextAlignmentCenter;
    cutLabel.textColor = kHexColor(@"#1C2B36");
    cutLabel.font = kFont(12);
    self.cutLabel = cutLabel;
    [self.contentView addSubview:cutLabel];
    
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
    
    if ([SingleInstance boolForKey:DiscShowKey]) {
        UILabel *discLabel = [[UILabel alloc] init];
        discLabel.textAlignment = NSTextAlignmentCenter;
        discLabel.textColor = kHexColor(@"#1C2B36");
        discLabel.font = kFont(12);
        discLabel.adjustsFontSizeToFitWidth = YES;
        self.discLabel = discLabel;
        [self.contentView addSubview:discLabel];
    }
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = kHexColor(@"#1C2B36");
    moneyLabel.font = kFont(12);
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    self.moneyLabel = moneyLabel;
    [self.contentView addSubview:moneyLabel];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = COLOR_LINE;
    self.dividerLine1 = dividerLine1;
    [self.contentView addSubview:dividerLine1];
    // 形状添加到线下面
    UIImageView *shapeIV = [[UIImageView alloc] init];
    self.shapeIV = shapeIV;
    [self.contentView addSubview:shapeIV];
    UIImageView *colorIV = [[UIImageView alloc] init];
    self.colorIV = colorIV;
    UIView *dividerLine2 = [[UIView alloc] init];
    dividerLine2.backgroundColor = COLOR_LINE;
    self.dividerLine2 = dividerLine2;
    [self.contentView addSubview:dividerLine2];
    [self.contentView addSubview:colorIV];
    
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
    [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        if (self.viewModel.clickOperation) self.viewModel.clickOperation(sender.selected);
    }];
    
    DiamInfoView *infoView = [[DiamInfoView alloc] init];
    self.infoView = infoView;
    [self.contentView addSubview:infoView];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.04);
        make.height.mas_equalTo(self.selectBtn.mas_width);
        make.bottom.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectBtn.mas_bottom);
        make.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.08);
        make.height.mas_equalTo(ZGCConvertToPx(16));
    }];
    [self.selectClearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.08);
        make.height.mas_equalTo(self.selectBtn.mas_width);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.statusLabel.mas_right);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
        make.height.mas_equalTo(ZGCConvertToPx(40));
    }];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.clarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorLabel);
        make.left.mas_equalTo(self.colorLabel.mas_right);
        make.bottom.mas_equalTo(self.colorLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.cutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.clarityLabel);
        make.left.mas_equalTo(self.clarityLabel.mas_right);
        make.bottom.mas_equalTo(self.clarityLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.polishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cutLabel);
        make.left.mas_equalTo(self.cutLabel.mas_right);
        make.bottom.mas_equalTo(self.cutLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.symLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.polishLabel);
        make.left.mas_equalTo(self.polishLabel.mas_right);
        make.bottom.mas_equalTo(self.polishLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    [self.flourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.symLabel);
        make.left.mas_equalTo(self.symLabel.mas_right);
        make.bottom.mas_equalTo(self.symLabel.mas_bottom);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.09);
    }];
    if ([SingleInstance boolForKey:DiscShowKey]) {
        [self.discLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.flourLabel);
            make.left.mas_equalTo(self.flourLabel.mas_right);
            make.bottom.mas_equalTo(self.flourLabel.mas_bottom);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.11);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.discLabel);
            make.left.mas_equalTo(self.discLabel.mas_right);
            make.bottom.mas_equalTo(self.discLabel.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
    } else {
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.flourLabel);
            make.left.mas_equalTo(self.flourLabel.mas_right);
            make.bottom.mas_equalTo(self.flourLabel.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
    }
    
    [self.shapeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ZGCConvertToPx(15), ZGCConvertToPx(15)));
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(53));
    }];
    [self.colorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ZGCConvertToPx(15), ZGCConvertToPx(15)));
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(80));
    }];
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.statusLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.sizeLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.colorLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.clarityLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.cutLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.polishLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    [self.dividerLine7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.symLabel.mas_right).offset(-0.5);
        make.width.mas_equalTo(1);
    }];
    if ([SingleInstance boolForKey:DiscShowKey]) {
        [self.dividerLine8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
            make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
        [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
            make.left.mas_equalTo(self.discLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    } else {
        [self.dividerLine9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
            make.left.mas_equalTo(self.flourLabel.mas_right).offset(-0.5);
            make.width.mas_equalTo(1);
        }];
    }
    [self.dividerLineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.dividerLine1.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.dividerLine1.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.dividerLineH);
    }];
    
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLineH.mas_bottom);
        make.left.mas_equalTo(self.dividerLine1.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
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
