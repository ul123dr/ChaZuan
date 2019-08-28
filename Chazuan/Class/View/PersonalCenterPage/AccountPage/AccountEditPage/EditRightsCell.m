//
//  EditRightsCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRightsCell.h"
#import "RightButton.h"

@interface EditRightsCell ()

// viewModel
@property (nonatomic, readwrite, strong) EditRightsItemViewModel *viewModel;
@property (nonatomic, readwrite, assign) BOOL areaShow;
@property (nonatomic, readwrite, strong) RightButton *areaBtn;
@property (nonatomic, readwrite, assign) BOOL certShow;
@property (nonatomic, readwrite, strong) RightButton *certBtn;
@property (nonatomic, readwrite, assign) BOOL detailShow;
@property (nonatomic, readwrite, strong) RightButton *detailBtn;
@property (nonatomic, readwrite, assign) BOOL rapShow;
@property (nonatomic, readwrite, strong) RightButton *rapBtn;
@property (nonatomic, readwrite, assign) BOOL rapBuyShow;
@property (nonatomic, readwrite, strong) RightButton *rapBuyBtn;
@property (nonatomic, readwrite, assign) BOOL discShow;
@property (nonatomic, readwrite, strong) RightButton *discBtn;
@property (nonatomic, readwrite, assign) BOOL mbgShow;
@property (nonatomic, readwrite, strong) RightButton *mbgBtn;
@property (nonatomic, readwrite, assign) BOOL blackShow;
@property (nonatomic, readwrite, strong) RightButton *blackBtn;
@property (nonatomic, readwrite, assign) BOOL fancyRapShow;
@property (nonatomic, readwrite, strong) RightButton *fancyRapBtn;
@property (nonatomic, readwrite, assign) BOOL imgShow;
@property (nonatomic, readwrite, strong) RightButton *imgBtn;
@property (nonatomic, readwrite, assign) BOOL dollarShow;
@property (nonatomic, readwrite, strong) RightButton *dollarBtn;
@property (nonatomic, readwrite, assign) BOOL realGoodsShow;
@property (nonatomic, readwrite, strong) RightButton *realGoodsBtn;
@property (nonatomic, readwrite, assign) BOOL sizeShow;
@property (nonatomic, readwrite, strong) RightButton *sizeBtn;
@property (nonatomic, readwrite, assign) BOOL isEyeCleanShow;
@property (nonatomic, readwrite, strong) RightButton *isEyeCleanBtn;
@property (nonatomic, readwrite, assign) BOOL isDTShow;
@property (nonatomic, readwrite, strong) RightButton *isDTBtn;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@property (nonatomic, readwrite, strong) NSMutableArray *btnList;

@end

@implementation EditRightsCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"EditRightsCell";
    EditRightsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(EditRightsItemViewModel *)viewModel {
    self.viewModel = viewModel;
    if (self.areaShow) RAC(self.areaBtn, selected) = [RACObserve(viewModel, area) takeUntil:self.rac_prepareForReuseSignal];
    if (self.certShow) RAC(self.certBtn, selected) = [RACObserve(viewModel, cert) takeUntil:self.rac_prepareForReuseSignal];
    if (self.detailShow) RAC(self.detailBtn, selected) = [RACObserve(viewModel, detail) takeUntil:self.rac_prepareForReuseSignal];
    if (self.rapShow) RAC(self.rapBtn, selected) = [RACObserve(viewModel, rap) takeUntil:self.rac_prepareForReuseSignal];
    if (self.rapBuyShow) RAC(self.rapBuyBtn, selected) = [RACObserve(viewModel, rapBuy) takeUntil:self.rac_prepareForReuseSignal];
    if (self.discShow) RAC(self.discBtn, selected) = [RACObserve(viewModel, disc) takeUntil:self.rac_prepareForReuseSignal];
    if (self.mbgShow) RAC(self.mbgBtn, selected) = [RACObserve(viewModel, mbg) takeUntil:self.rac_prepareForReuseSignal];
    if (self.blackShow) RAC(self.blackBtn, selected) = [RACObserve(viewModel, black) takeUntil:self.rac_prepareForReuseSignal];
    if (self.fancyRapShow) RAC(self.fancyRapBtn, selected) = [RACObserve(viewModel, fancyRap) takeUntil:self.rac_prepareForReuseSignal];
    if (self.imgShow) RAC(self.imgBtn, selected) = [RACObserve(viewModel, img) takeUntil:self.rac_prepareForReuseSignal];
    if (self.dollarShow) RAC(self.dollarBtn, selected) = [RACObserve(viewModel, dollar) takeUntil:self.rac_prepareForReuseSignal];
    if (self.realGoodsShow) RAC(self.realGoodsBtn, selected) = [RACObserve(viewModel, realGoodsNumber) takeUntil:self.rac_prepareForReuseSignal];
    if (self.sizeShow) RAC(self.sizeBtn, selected) = [RACObserve(viewModel, size) takeUntil:self.rac_prepareForReuseSignal];
    if (self.isEyeCleanShow) RAC(self.isEyeCleanBtn, selected) = [RACObserve(viewModel, isEyeClean) takeUntil:self.rac_prepareForReuseSignal];
    if (self.isDTShow) RAC(self.isDTBtn, selected) = [RACObserve(viewModel, isDT) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self);
    [RACObserve(viewModel, shouldEdited) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        for (ZGButton *btn in self.btnList) {
            btn.enabled = x.boolValue;
        }
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
    self.btnList = [NSMutableArray array];
    NSInteger userLevel = [HTTPService sharedInstance].currentUser.userType;
    self.areaShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:AddressShowKey];
    self.certShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:CertShowKey];
    self.detailShow = (userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:RapIdShowKey]) && [SingleInstance numberForKey:DiamondShowPowerMasterKey].integerValue == 1;
    self.rapShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:RapShowKey];
    self.rapBuyShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:RapBuyShowKey];
    self.discShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:DiscShowKey];
    self.mbgShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:MbgShowKey];
    self.blackShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:BlackShowKey];
    self.fancyRapShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:FancyRapKey];
    self.imgShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:ImgShowKey];
    self.dollarShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:DollarShowKey];
    self.realGoodsShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:GoodsNumberShowKey];
    self.sizeShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:SizeShowKey];
    self.isEyeCleanShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:EyeCleanShowKey];
    self.isDTShow = userLevel == 99 || userLevel == 5 || [SingleInstance boolForKey:DTShowKey];
}

- (void)_setupSubviews {
    @weakify(self);
    if (self.areaShow) {
        RightButton *areaBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        areaBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        areaBtn.nameLabel.text = @"地区显示";
        areaBtn.nameLabel.font = kFont(12);
        self.areaBtn = areaBtn;
        [self.contentView addSubview:areaBtn];
        [self.btnList addObject:areaBtn];
        [[areaBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.area = !sender.selected;
        }];
    }
    if (self.certShow) {
        RightButton *certBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        certBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        certBtn.nameLabel.text = @"证书号显示";
        certBtn.nameLabel.font = kFont(12);
        self.certBtn = certBtn;
        [self.contentView addSubview:certBtn];
        [self.btnList addObject:certBtn];
        [[certBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.cert = !sender.selected;
        }];
    }
    if (self.detailShow) {
        RightButton *detailBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        detailBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        detailBtn.nameLabel.text = @"供应商显示";
        detailBtn.nameLabel.font = kFont(12);
        self.detailBtn = detailBtn;
        [self.contentView addSubview:detailBtn];
        [self.btnList addObject:detailBtn];
        [[detailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.detail = !sender.selected;
        }];
    }
    if (self.rapShow) {
        RightButton *rapBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        rapBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        rapBtn.nameLabel.text = @"国际报价显示";
        rapBtn.nameLabel.font = kFont(12);
        self.rapBtn = rapBtn;
        [self.contentView addSubview:rapBtn];
        [self.btnList addObject:rapBtn];
        [[rapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.rap = !sender.selected;
        }];
    }
    if (self.rapBuyShow) {
        RightButton *rapBuyBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        rapBuyBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        rapBuyBtn.nameLabel.text = @"购美金/粒显示";
        rapBuyBtn.nameLabel.font = kFont(12);
        self.rapBuyBtn = rapBuyBtn;
        [self.contentView addSubview:rapBuyBtn];
        [self.btnList addObject:rapBuyBtn];
        [[rapBuyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.rapBuy = !sender.selected;
        }];
    }
    if (self.discShow) {
        RightButton *discBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        discBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        discBtn.nameLabel.text = @"折扣显示";
        discBtn.nameLabel.font = kFont(12);
        self.discBtn = discBtn;
        [self.contentView addSubview:discBtn];
        [self.btnList addObject:discBtn];
        [[discBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.disc = !sender.selected;
        }];
    }
    if (self.mbgShow) {
        RightButton *mbgBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        mbgBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        mbgBtn.nameLabel.text = @"奶咖绿显示";
        mbgBtn.nameLabel.font = kFont(12);
        self.mbgBtn = mbgBtn;
        [self.contentView addSubview:mbgBtn];
        [self.btnList addObject:mbgBtn];
        [[mbgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.mbg = !sender.selected;
        }];
    }
    if (self.blackShow) {
        RightButton *blackBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        blackBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        blackBtn.nameLabel.text = @"黑包/白包显示";
        blackBtn.nameLabel.font = kFont(12);
        self.blackBtn = blackBtn;
        [self.contentView addSubview:blackBtn];
        [self.btnList addObject:blackBtn];
        [[blackBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.black = !sender.selected;
        }];
    }
    if (self.fancyRapShow) {
        RightButton *fancyRapBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        fancyRapBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        fancyRapBtn.nameLabel.text = @"彩钻$/Ct显示";
        fancyRapBtn.nameLabel.font = kFont(12);
        self.fancyRapBtn = fancyRapBtn;
        [self.contentView addSubview:fancyRapBtn];
        [self.btnList addObject:fancyRapBtn];
        [[fancyRapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.fancyRap = !sender.selected;
        }];
    }
    if (self.imgShow) {
        RightButton *imgBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        imgBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        imgBtn.nameLabel.text = @"钻石图片显示";
        imgBtn.nameLabel.font = kFont(12);
        self.imgBtn = imgBtn;
        [self.contentView addSubview:imgBtn];
        [self.btnList addObject:imgBtn];
        [[imgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.img = !sender.selected;
        }];
    }
    if (self.dollarShow) {
        RightButton *dollarBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        dollarBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        dollarBtn.nameLabel.text = @"汇率显示";
        dollarBtn.nameLabel.font = kFont(12);
        self.dollarBtn = dollarBtn;
        [self.contentView addSubview:dollarBtn];
        [self.btnList addObject:dollarBtn];
        [[dollarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.dollar = !sender.selected;
        }];
    }
    if (self.realGoodsShow) {
        RightButton *realGoodsBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        realGoodsBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        realGoodsBtn.nameLabel.text = @"真实货号显示";
        realGoodsBtn.nameLabel.font = kFont(12);
        self.realGoodsBtn = realGoodsBtn;
        [self.contentView addSubview:realGoodsBtn];
        [self.btnList addObject:realGoodsBtn];
        [[realGoodsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.realGoodsNumber = !sender.selected;
        }];
    }
    if (self.sizeShow) {
        RightButton *sizeBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        sizeBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        sizeBtn.nameLabel.text = @"尺寸显示";
        sizeBtn.nameLabel.font = kFont(12);
        self.sizeBtn = sizeBtn;
        [self.contentView addSubview:sizeBtn];
        [self.btnList addObject:sizeBtn];
        [[sizeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.size = sender.selected;
        }];
    }
    if (self.isEyeCleanShow) {
        RightButton *isEyeCleanBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        isEyeCleanBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        isEyeCleanBtn.nameLabel.text = @"肉色干净显示";
        isEyeCleanBtn.nameLabel.font = kFont(12);
        self.isEyeCleanBtn = isEyeCleanBtn;
        [self.contentView addSubview:isEyeCleanBtn];
        [self.btnList addObject:isEyeCleanBtn];
        [[isEyeCleanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.isEyeClean = !sender.selected;
        }];
    }
    if (self.isDTShow) {
        RightButton *isDTBtn = [RightButton buttonWithType:UIButtonTypeCustom];
        isDTBtn.nameLabel.textColor = kHexColor(@"#98A2A9");
        isDTBtn.nameLabel.text = @"全深比/台宽比";
        isDTBtn.nameLabel.font = kFont(12);
        self.isDTBtn = isDTBtn;
        [self.contentView addSubview:isDTBtn];
        [self.btnList addObject:isDTBtn];
        [[isDTBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RightButton *sender) {
            @strongify(self);
            self.viewModel.isDT = !sender.selected;
        }];
    }
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    for (RightButton *btn in self.btnList) {
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(RightButton *btn) {
            btn.selected = !btn.selected;
        }];
    }
}

- (void)_setupSubviewsConstraint {
    ZGButton *tempBtn, *flourBtn;
    for (int i = 0; i < self.btnList.count; i++) {
        ZGButton *btn = self.btnList[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%3 == 0) {
                make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
            } else {
                make.left.mas_equalTo(tempBtn.mas_right);
                if (i%3 == 2)
                    make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
            }
            if (i/3 == 0) {
                make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(8));
            } else {
                if (i%3==0)
                    make.top.mas_equalTo(flourBtn.mas_bottom);
                else
                    make.top.mas_equalTo(flourBtn);
                if (i == self.btnList.count-1)
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-8));
            }
            if (tempBtn) make.size.mas_equalTo(tempBtn);
        }];
        tempBtn = btn;
        if (i%3 == 0) flourBtn = btn;
    }
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
