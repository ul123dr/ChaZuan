//
//  DiamInfoView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/12.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamInfoView.h"
#import "DiamResultList.h"
#import "DiamSupplyList.h"

@interface DiamInfoView ()<UITextViewDelegate>

@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, readwrite, strong) NSMutableArray *selectBtns;

@property (nonatomic, readwrite, strong) NSMutableArray *lines;

@property (nonatomic, readwrite, strong) UIView *leftLine;
@property (nonatomic, readwrite, strong) UIView *rightLine;

@property (nonatomic, readwrite, strong) UITextView *temp1Label;
@property (nonatomic, readwrite, strong) UITextView *temp2Label;
@property (nonatomic, readwrite, strong) UITextView *temp3Label;
@property (nonatomic, readwrite, strong) UITextView *temp4Label;
@property (nonatomic, readwrite, strong) UITextView *temp5Label;
@property (nonatomic, readwrite, strong) UITextView *temp6Label;
@property (nonatomic, readwrite, strong) UITextView *temp7Label;
@property (nonatomic, readwrite, strong) UITextView *temp8Label;
@property (nonatomic, readwrite, strong) UITextView *temp9Label;

@property (nonatomic, readwrite, strong) UITextField *addTF;
@property (nonatomic, readwrite, strong) ZGButton *addBtn;
@property (nonatomic, readwrite, strong) ZGButton *minusBtn;

@property (nonatomic, readwrite, strong) UITextField *rateTF;

@property (nonatomic, readwrite, strong) ZGButton *certBtn;
@property (nonatomic, readwrite, strong) ZGButton *quoteBtn;

@property (nonatomic, readwrite, assign) BOOL rapShow;
@property (nonatomic, readwrite, assign) BOOL discShow;
@property (nonatomic, readwrite, assign) BOOL rapBuyShow;
@property (nonatomic, readwrite, assign) BOOL certShow;

@end

@implementation DiamInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
        [self _bind];
    }
    return self;
}

- (void)setList:(DiamResultList *)list {
    _list = list;
    ZGButton *btn = self.selectBtns.firstObject;
    [self updateContent:btn.tag];
    [self _updateFrames:btn];
}

- (void)updateContent:(NSInteger)type {
    self.temp1Label.text = @"";
    self.temp2Label.text = @"";
    self.temp3Label.text = @"";
    self.temp4Label.text = @"";
    self.temp5Label.text = @"";
    self.temp6Label.text = @"";
    self.temp7Label.text = @"";
    self.temp8Label.text = @"";
    self.temp9Label.text = @"";
    self.addTF.text = @"0.00";
    self.rateTF.text = @"0.00";
    self.certBtn.hidden = YES;
    
    if (type == 1) {
        self.temp1Label.text = [NSString stringWithFormat:@"国际报价：$%.2f", self.list.rap.floatValue];
        self.temp2Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
        self.temp3Label.text = @"预售加点：";
        self.addTF.text = self.addNum;
        self.temp4Label.text = [NSString stringWithFormat:@"预售折扣：%.2f", 0-self.list.disc.floatValue+self.addNum.floatValue];
        self.temp5Label.text = @"汇　　率：";
        self.rateTF.text = [NSString stringWithFormat:@"%.2f", self.rate.floatValue];
        CGFloat num = (100-self.list.disc.floatValue+self.addNum.floatValue)/100.0;
        self.temp6Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num)];
        self.temp7Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num*self.list.dSize.floatValue)];
    } else if (type == 2) {
        if (self.rapShow) {
            self.temp1Label.text = [NSString stringWithFormat:@"国际报价：$%.2f", self.list.rap.floatValue];
            self.temp2Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
        } else {
            self.temp1Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
        }
        if (self.discShow) {
            CGFloat num = (100-self.list.disc.floatValue)/100.0;
            CGFloat round1 = round(self.list.rap.floatValue*self.rate.floatValue*num);
            CGFloat round2 = round(self.list.rap.floatValue*self.rate.floatValue*num*self.list.dSize.floatValue);
            if (self.rapShow) {
                self.temp3Label.text = [NSString stringWithFormat:@"折　　扣：%.2f", 0-self.list.disc.floatValue+self.addNum.floatValue];
                self.temp4Label.text = [NSString stringWithFormat:@"推荐折扣：%.2f", 0-self.list.disc.floatValue];
                if (self.rapBuyShow) {
                    self.temp5Label.text = [NSString stringWithFormat:@"购美金/粒： $%.2f", round(self.list.rate.doubleValue)];
                    self.temp6Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round1];
                    self.temp7Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round2];
                } else {
                    self.temp5Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round1];
                    self.temp6Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round2];
                }
            } else {
                self.temp2Label.text = [NSString stringWithFormat:@"折　　扣：%.2f", 0-self.list.disc.floatValue+self.addNum.floatValue];
                self.temp3Label.text = [NSString stringWithFormat:@"推荐折扣：%.2f", 0-self.list.disc.floatValue];
//                CGFloat num = (100-self.list.disc.floatValue+self.addNum.floatValue)/100.0;
                if (self.rapBuyShow) {
                    self.temp4Label.text = [NSString stringWithFormat:@"购美金/粒： $%.2f", round(self.list.rate.doubleValue)];
                    self.temp5Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round1];
                    self.temp6Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round2];
                } else {
                    self.temp4Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round1];
                    self.temp5Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round2];
                }
            }
        }
    } else if (type == 3) {
        self.temp1Label.text = [NSString stringWithFormat:@"形状：%@　　切工：%@　　抛光：%@", formatString(self.list.shape), formatString(self.list.cut), formatString(self.list.polish)];
        
        NSArray *statusArr = @[@"订货",@"在库",@"预售",@"借出",@"锁定",@"现货"];
        BOOL lock = self.list.sysStatus.integerValue == 4 || self.list.sysStatus.integerValue >= statusArr.count;
        NSString *status =  self.list.sysStatus.integerValue<statusArr.count?statusArr[self.list.sysStatus.integerValue]:@"锁定";
        NSString *temp2 = [NSString stringWithFormat:@"对称：%@　　荧光：%@　　状态：%@", formatString(self.list.sym), formatString(self.list.flour), status];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:temp2];
        [attrStr addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, temp2.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:lock?kHexColor(@"#f85359"):kHexColor(@"#3882ff") range:NSMakeRange(temp2.length-status.length, status.length)];
        self.temp2Label.attributedText = attrStr;
        
        NSString *certStr = self.list.cert.uppercaseString;
        self.temp3Label.text = [NSString stringWithFormat:@"证书：%@", certStr];
        if (self.certShow && ([certStr containsString:@"GIA"] || [certStr containsString:@"IGI"] || [certStr containsString:@"EGL"] || [certStr containsString:@"HRD"])) {
            self.certBtn.hidden = NO;
        }
        
        NSString *temp4 = [NSString stringWithFormat:@"证书号：%@", self.certShow?formatString(self.list.certNo):@"-"];
        if ([SingleInstance boolForKey:EyeCleanShowKey]) temp4 = [temp4 stringByAppendingFormat:@"　　肉眼干净：%@", formatString(self.list.eyeClean)];
        NSMutableAttributedString *attr4 = [[NSMutableAttributedString alloc] initWithString:temp4];
        [attr4 addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, temp4.length)];
        if (self.certShow) {
//            [attr4 addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#3882ff") range:NSMakeRange(4, formatString(self.list.certNo).length)];
            [attr4 addAttribute:NSLinkAttributeName value:@"lookcert://" range:NSMakeRange(4,formatString(self.list.certNo).length)];
        }
        self.temp4Label.attributedText = attr4;
        
        NSString *milkStr = @"";
        if ([SingleInstance boolForKey:MbgShowKey]) {
            if ([self.list.milky containsString:@"M"]) {
                milkStr = [milkStr stringByAppendingString:@"奶色：有奶"];
            } else if ([self.list.milky containsString:@"N"]) {
                milkStr = [milkStr stringByAppendingString:@"奶色：无奶"];
            } else if (kStringIsNotEmpty(self.list.milky)) {
                milkStr = [milkStr stringByAppendingFormat:@"奶色：%@", self.list.milky];
            } else {
                milkStr = [milkStr stringByAppendingString:@"奶色：待查"];
            }
            if ([self.list.browness containsString:@"B"]) {
                milkStr = [milkStr stringByAppendingString:@"　　咖色：有咖"];
            } else if ([self.list.browness containsString:@"N"]) {
                milkStr = [milkStr stringByAppendingString:@"　　咖色：无咖"];
            } else if (kStringIsNotEmpty(self.list.browness)) {
                milkStr = [milkStr stringByAppendingFormat:@"　　咖色：%@", self.list.browness];
            } else {
                milkStr = [milkStr stringByAppendingString:@"　　咖色：待查"];
            }
        }
        NSString *blackStr = @"";
        if ([SingleInstance boolForKey:BlackShowKey]) {
            blackStr = [NSString stringWithFormat:@"黑色包体：%@ %@　　白色包体：%@ %@", formatString(self.list.bt), formatString(self.list.bc), formatString(self.list.wt), formatString(self.list.wc)];
        }
        NSString *dtStr = @"";
        if ([SingleInstance boolForKey:DTShowKey]) {
            dtStr = [NSString stringWithFormat:@"全深比：%@　　台宽比：%@", formatString(self.list.dDepth), formatString(self.list.dTable)];
        }
        NSString *sizeStr = @"";
        if ([SingleInstance boolForKey:SizeShowKey]) {
            if (self.list.m1) {
                sizeStr = [NSString stringWithFormat:@"尺寸：%@", self.list.m1];
                if (self.list.m2 && self.list.m3) sizeStr = [sizeStr stringByAppendingFormat:@" x %@ x %@", self.list.m2, self.list.m3];
            } else {
                sizeStr = @"尺寸：-";
            }
            
            if ([SingleInstance boolForKey:ImgShowKey]) {
                sizeStr = [sizeStr stringByAppendingString:@"　　图片："];
                if ((kStringIsNotEmpty(self.list.daylight) && ![self.list.daylight isEqualToString:@"-"]) || (kStringIsNotEmpty(self.list.video) && ![self.list.daylight isEqualToString:@"-"])) {
                    sizeStr = [sizeStr stringByAppendingString:@"查看"];
                } else {
                    sizeStr = [sizeStr stringByAppendingString:@"-"];
                }
            }
        }
        
        NSString *goodNumStr = [NSString stringWithFormat:@"原货号：%@", formatString([SingleInstance boolForKey:GoodsNumberShowKey]?self.list.dRef:self.list.oldRef)];
        if ([SingleInstance boolForKey:AddressShowKey]) goodNumStr = [goodNumStr stringByAppendingFormat:@"　　所在地：%@", self.list.location];
        NSMutableAttributedString *sizeAttr;
        if ([sizeStr containsString:@"查看"]) {
            sizeAttr = [[NSMutableAttributedString alloc] initWithString:sizeStr];
            [sizeAttr addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, sizeStr.length)];
            [sizeAttr addAttribute:NSLinkAttributeName value:@"lookpic://" range:NSMakeRange(sizeStr.length-@"查看".length,2)];
        }
        if ([SingleInstance boolForKey:MbgShowKey]) {
            self.temp5Label.text = milkStr;
            if ([SingleInstance boolForKey:BlackShowKey]) {
                self.temp6Label.text = blackStr;
                if ([SingleInstance boolForKey:DTShowKey]) {
                    self.temp7Label.text = dtStr;
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp8Label.attributedText = sizeAttr;
                        else self.temp8Label.text = sizeStr;
                        self.temp9Label.text = goodNumStr;
                    } else {
                        self.temp8Label.text = goodNumStr;
                    }
                } else {
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp7Label.attributedText = sizeAttr;
                        else self.temp7Label.text = sizeStr;
                        self.temp8Label.text = goodNumStr;
                    } else {
                        self.temp7Label.text = goodNumStr;
                    }
                }
            } else {
                if ([SingleInstance boolForKey:DTShowKey]) {
                    self.temp6Label.text = dtStr;
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp7Label.attributedText = sizeAttr;
                        else self.temp7Label.text = sizeStr;
                        self.temp8Label.text = goodNumStr;
                    } else {
                        self.temp7Label.text = goodNumStr;
                    }
                } else {
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp6Label.attributedText = sizeAttr;
                        else self.temp6Label.text = sizeStr;
                        self.temp7Label.text = goodNumStr;
                    } else {
                        self.temp6Label.text = goodNumStr;
                    }
                }
            }
        } else {
            if ([SingleInstance boolForKey:BlackShowKey]) {
                self.temp5Label.text = blackStr;
                if ([SingleInstance boolForKey:DTShowKey]) {
                    self.temp6Label.text = dtStr;
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp7Label.attributedText = sizeAttr;
                        else self.temp7Label.text = sizeStr;
                        self.temp8Label.text = goodNumStr;
                    } else {
                        self.temp7Label.text = goodNumStr;
                    }
                } else {
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp6Label.attributedText = sizeAttr;
                        else self.temp6Label.text = sizeStr;
                        self.temp7Label.text = goodNumStr;
                    } else {
                        self.temp6Label.text = goodNumStr;
                    }
                }
            } else {
                if ([SingleInstance boolForKey:DTShowKey]) {
                    self.temp5Label.text = dtStr;
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp6Label.attributedText = sizeAttr;
                        else self.temp6Label.text = sizeStr;
                        self.temp7Label.text = goodNumStr;
                    } else {
                        self.temp6Label.text = goodNumStr;
                    }
                } else {
                    if ([SingleInstance boolForKey:SizeShowKey]) {
                        if (sizeAttr.length > 0) self.temp5Label.attributedText = sizeAttr;
                        else self.temp5Label.text = sizeStr;
                        self.temp6Label.text = goodNumStr;
                    } else {
                        self.temp5Label.text = goodNumStr;
                    }
                }
            }
        }
    } else if (type == 4) {
        self.temp1Label.text = [NSString stringWithFormat:@"简　　称：%@", formatString(self.supplyList.supplierSimpleName)];
        self.temp2Label.text = [NSString stringWithFormat:@"全　　称：%@", formatString(self.supplyList.supplierNameTrue)];
        self.temp3Label.text = [NSString stringWithFormat:@"　RapID：%@", formatString(self.list.detail)];
        self.temp4Label.text = [NSString stringWithFormat:@"　Skype：%@", formatString(self.supplyList.skype)];
        self.temp5Label.text = [NSString stringWithFormat:@"　 　QQ：%@", formatString(self.supplyList.qq)];
        self.temp6Label.text = [NSString stringWithFormat:@"手机号码：%@", formatString(self.supplyList.mobile)];
        self.temp7Label.text = [NSString stringWithFormat:@"WHATSAPP：%@", formatString(self.supplyList.whatsapp)];
        self.temp8Label.text = [NSString stringWithFormat:@"网　　址：%@", formatString(self.supplyList.supplierWww)];
        
        NSString *www = [NSString stringWithFormat:@"网　　址：%@", formatString(self.supplyList.supplierWww)];
        if (kStringIsNotEmpty(self.supplyList.supplierWww) && ![self.supplyList.supplierWww isEqualToString:@"-"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:www];
            [attr addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, www.length)];
            [attr addAttribute:NSLinkAttributeName value:@"wwwUrl://" range:NSMakeRange(5,formatString(self.supplyList.supplierWww).length)];
            self.temp8Label.attributedText = attr;
        } else {
            self.temp8Label.text = www;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"lookcert"]) {
        [self.clickSub sendNext:[RACTuple tupleWithObjects:@(2), @(self.index), nil]];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"lookpic"]) {
        [self.clickSub sendNext:[RACTuple tupleWithObjects:@(3), @(self.index), nil]];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"wwwUrl"]) {
        [self.clickSub sendNext:[RACTuple tupleWithObjects:@(4), @(self.index), self.supplyList.supplierWww, nil]];
        return NO;
    }
    return YES;
}

- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
    self.selectTag = 1;
    self.selectBtns = [NSMutableArray array];
    self.lines = [NSMutableArray array];
    self.addNum = @"0.00";
    self.rapShow = [SingleInstance boolForKey:RapShowKey];
    self.discShow = [SingleInstance boolForKey:DiscShowKey];
    self.rapBuyShow = [SingleInstance boolForKey:RapBuyShowKey];
    self.certShow = [SingleInstance boolForKey:CertShowKey];
}

- (void)_setupSubviews {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = kHexColor(@"#B2B2B2").CGColor;
    self.contentView = contentView;
    [self addSubview:contentView];
    
    if (self.rapShow && self.discShow) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"报价信息" forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(12)];
        btn.tag = 1;
        [contentView addSubview:btn];
        [self.selectBtns addObject:btn];
    }
    ZGButton *btn1 = [ZGButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"成本信息" forState:UIControlStateNormal];
    [btn1 setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [btn1.titleLabel setFont:kFont(12)];
    btn1.tag = 2;
    [contentView addSubview:btn1];
    [self.selectBtns addObject:btn1];
    ZGButton *btn2 = [ZGButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"基本信息" forState:UIControlStateNormal];
    [btn2 setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [btn2.titleLabel setFont:kFont(12)];
    btn2.tag = 3;
    [contentView addSubview:btn2];
    [self.selectBtns addObject:btn2];
    if (self.rapBuyShow) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"商家信息" forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(12)];
        btn.tag = 4;
        [contentView addSubview:btn];
        [self.selectBtns addObject:btn];
    }
    
    for (int i = 0; i < self.selectBtns.count-1; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kHexColor(@"#B2B2B2");
        [contentView addSubview:line];
        [self.lines addObject:line];
    }
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = kHexColor(@"#B2B2B2");
    self.leftLine = leftLine;
    [contentView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = kHexColor(@"#B2B2B2");
    self.rightLine = rightLine;
    [contentView addSubview:rightLine];
    
    UITextView *temp1Label = [[UITextView alloc] init];
    temp1Label.editable = NO;
    temp1Label.scrollEnabled = NO;
    temp1Label.delegate = self;
    temp1Label.textColor = kHexColor(@"#1C2B36");
    temp1Label.font = kFont(14);
    self.temp1Label = temp1Label;
    [contentView addSubview:temp1Label];
    
    UITextView *temp2Label = [[UITextView alloc] init];
    temp2Label.editable = NO;
    temp2Label.scrollEnabled = NO;
    temp2Label.delegate = self;
    temp2Label.textColor = kHexColor(@"#1C2B36");
    temp2Label.font = kFont(14);
    self.temp2Label = temp2Label;
    [contentView addSubview:temp2Label];
    
    UITextView *temp3Label = [[UITextView alloc] init];
    temp3Label.editable = NO;
    temp3Label.scrollEnabled = NO;
    temp3Label.delegate = self;
    temp3Label.textColor = kHexColor(@"#1C2B36");
    temp3Label.font = kFont(14);
    self.temp3Label = temp3Label;
    [contentView addSubview:temp3Label];
    
    UITextField *addTF = [[UITextField alloc] init];
    addTF.layer.borderColor = COLOR_LINE.CGColor;
    addTF.layer.borderWidth = 1;
    addTF.font = kFont(15);
    addTF.textColor = kHexColor(@"#1C2B36");
    addTF.keyboardType = UIKeyboardTypeDecimalPad;
    addTF.textAlignment = NSTextAlignmentCenter;
    self.addTF = addTF;
    [contentView addSubview:addTF];
    
    ZGButton *leftBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:ImageNamed(@"disc_add") forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(8), ZGCConvertToPx(9.375), ZGCConvertToPx(8), ZGCConvertToPx(9.375));
    [addTF addSubview:leftBtn];
    self.addBtn = leftBtn;
    
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"disc_remove") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(8), ZGCConvertToPx(9.375), ZGCConvertToPx(8), ZGCConvertToPx(9.375));
    [addTF addSubview:rightBtn];
    self.minusBtn = rightBtn;
    
    ZGButton *certBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    certBtn.hidden = YES;
    certBtn.backgroundColor = kHexColor(@"#3882FF");
    certBtn.layer.cornerRadius = 4;
    [certBtn setTitle:@"证书查询" forState:UIControlStateNormal];
    [certBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [certBtn.titleLabel setFont:kFont(14)];
    self.certBtn = certBtn;
    [contentView addSubview:certBtn];
    
    UITextView *temp4Label = [[UITextView alloc] init];
    temp4Label.editable = NO;
    temp4Label.scrollEnabled = NO;
    temp4Label.delegate = self;
    temp4Label.textColor = kHexColor(@"#1C2B36");
    temp4Label.font = kFont(14);
    self.temp4Label = temp4Label;
    [contentView addSubview:temp4Label];
    
    UITextView *temp5Label = [[UITextView alloc] init];
    temp5Label.editable = NO;
    temp5Label.scrollEnabled = NO;
    temp5Label.delegate = self;
    temp5Label.textColor = kHexColor(@"#1C2B36");
    temp5Label.font = kFont(14);
    self.temp5Label = temp5Label;
    [contentView addSubview:temp5Label];
    
    UITextField *rateTF = [[UITextField alloc] init];
    rateTF.layer.borderColor = COLOR_LINE.CGColor;
    rateTF.layer.borderWidth = 1;
    rateTF.font = kFont(15);
    rateTF.textColor = kHexColor(@"#1C2B36");
    rateTF.keyboardType = UIKeyboardTypeDecimalPad;
    rateTF.textAlignment = NSTextAlignmentCenter;
    self.rateTF = rateTF;
    [contentView addSubview:rateTF];
    
    UITextView *temp6Label = [[UITextView alloc] init];
    temp6Label.editable = NO;
    temp6Label.scrollEnabled = NO;
    temp6Label.delegate = self;
    temp6Label.textColor = kHexColor(@"#1C2B36");
    temp6Label.font = kFont(14);
    self.temp6Label = temp6Label;
    [contentView addSubview:temp6Label];
    
    UITextView *temp7Label = [[UITextView alloc] init];
    temp7Label.editable = NO;
    temp7Label.scrollEnabled = NO;
    temp7Label.delegate = self;
    temp7Label.textColor = kHexColor(@"#1C2B36");
    temp7Label.font = kFont(14);
    self.temp7Label = temp7Label;
    [contentView addSubview:temp7Label];
    
    UITextView *temp8Label = [[UITextView alloc] init];
    temp8Label.editable = NO;
    temp8Label.scrollEnabled = NO;
    temp8Label.delegate = self;
    temp8Label.textColor = kHexColor(@"#1C2B36");
    temp8Label.font = kFont(14);
    self.temp8Label = temp8Label;
    [contentView addSubview:temp8Label];
    
    UITextView *temp9Label = [[UITextView alloc] init];
    temp9Label.editable = NO;
    temp9Label.scrollEnabled = NO;
    temp9Label.delegate = self;
    temp9Label.textColor = kHexColor(@"#1C2B36");
    temp9Label.font = kFont(14);
    self.temp9Label = temp9Label;
    [contentView addSubview:temp9Label];
    
    ZGButton *quoteBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    quoteBtn.backgroundColor = kHexColor(@"#3882FF");
    quoteBtn.layer.cornerRadius = 4;
    [quoteBtn setTitle:@"报价" forState:UIControlStateNormal];
    [quoteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [quoteBtn.titleLabel setFont:kFont(14)];
    self.quoteBtn = quoteBtn;
    [contentView addSubview:quoteBtn];
    
    for (int i = 0; i < self.selectBtns.count; i++) {
        ZGButton *btn = self.selectBtns[i];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            [self updateContent:sender.tag];
            [self _updateFrames:sender];
        }];
    }
    
    @weakify(self);
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        CGFloat addNum = self.addTF.text.floatValue;
        addNum ++;
        self.addTF.text = [NSString stringWithFormat:@"%.2f", addNum];
        self.addNum = self.addTF.text;
    }];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        CGFloat minusNum = self.addTF.text.floatValue;
        minusNum = minusNum -- < 1 ? 0 : minusNum;
        self.addTF.text = [NSString stringWithFormat:@"%.2f", minusNum];
        self.addNum = self.addTF.text;
    }];
    
    [[self.quoteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.clickSub sendNext:[RACTuple tupleWithObjects:@(0), @(self.index), nil]];
    }];
    
    [[self.certBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.clickSub sendNext:[RACTuple tupleWithObjects:@(1), @(self.index), nil]];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(10), ZGCConvertToPx(5), ZGCConvertToPx(5), ZGCConvertToPx(10)));
    }];
    
    ZGButton *tempBtn;
    for (int i = 0; i < self.selectBtns.count; i++) {
        ZGButton *btn = self.selectBtns[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.height.mas_equalTo(ZGCConvertToPx(32));
            if (tempBtn) {
                make.left.mas_equalTo(tempBtn.mas_right);
                make.width.mas_equalTo(tempBtn);
            } else {
                make.left.mas_equalTo(self.contentView);
            }
            if (i == self.selectBtns.count-1) make.right.mas_equalTo(self.contentView.mas_right);
        }];
        if (i == 0) {
            btn.selected = YES;
            self.selectTag = btn.tag;
        }
        if (tempBtn) {
            UIView *line = self.lines[i-1];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(tempBtn);
                make.left.mas_equalTo(tempBtn.mas_right).offset(-0.5);
                make.width.mas_equalTo(1);
            }];
        }
        tempBtn = btn;
    }
    
    [self.temp1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(39.5)+1);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.top.mas_equalTo(self.temp1Label.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp2Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.addTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(82));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-78));
        make.height.mas_equalTo(self.temp3Label);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.addTF);
        make.width.mas_equalTo(ZGCConvertToPx(37.5));
    }];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.addTF);
        make.width.mas_equalTo(ZGCConvertToPx(37.5));
    }];
    [self.certBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(142));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-78));
        make.height.mas_equalTo(self.temp3Label);
    }];
    [self.temp4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp4Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.rateTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp5Label);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(82));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-150));
        make.height.mas_equalTo(self.temp5Label);
    }];
    [self.temp6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp5Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp6Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp7Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.temp9Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp8Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    [self.quoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-30));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-54));
        make.size.mas_equalTo(CGSizeMake(ZGCConvertToPx(60), ZGCConvertToPx(32)));
    }];
}

- (void)_updateFrames:(ZGButton *)btn {
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(btn.mas_bottom);
        make.right.mas_equalTo(btn.mas_left);
        make.height.mas_equalTo(1);
    }];
    [self.rightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(btn.mas_bottom);
        make.left.mas_equalTo(btn.mas_right);
        make.height.mas_equalTo(1);
    }];
    self.addTF.hidden = btn.tag!=1;
    self.rateTF.hidden = btn.tag!=1;
    self.quoteBtn.hidden = btn.tag!=1;
    [self.temp3Label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZGCConvertToPx((btn.tag==1||btn.tag==3)?32:28));
    }];
    [self.temp5Label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZGCConvertToPx(btn.tag==1?32:28));
    }];
}

- (void)_bind {
    RACChannelTo(self, rate) = self.rateTF.rac_newTextChannel;
    RACChannelTo(self, addNum) = self.addTF.rac_newTextChannel;
    [RACObserve(self, addNum) subscribeNext:^(id  _Nullable x) {
        [self updateContent:1];
    }];
}

@end
