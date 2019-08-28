//
//  FancyInfoView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyInfoView.h"
#import "DiamResultList.h"
#import "DiamSupplyList.h"

@interface FancyInfoView ()<UITextViewDelegate>

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

@property (nonatomic, readwrite, strong) UITextField *addTF;
@property (nonatomic, readwrite, strong) ZGButton *addBtn;
@property (nonatomic, readwrite, strong) ZGButton *minusBtn;

@property (nonatomic, readwrite, strong) UITextField *rateTF;

@property (nonatomic, readwrite, strong) ZGButton *quoteBtn;

@property (nonatomic, readwrite, assign) BOOL fancyRapShow;
@property (nonatomic, readwrite, assign) BOOL dollarShow;
@property (nonatomic, readwrite, assign) BOOL certShow;

@end

@implementation FancyInfoView

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
    self.addTF.text = @"0.00";
    self.rateTF.text = @"0.00";
    
    if (type == 1) {
        self.temp1Label.text = [NSString stringWithFormat:@"　　$/Ct：%.2f", self.list.rap.floatValue];
        self.temp2Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
        self.temp3Label.text = @"倍　　率：";
        self.addTF.text = self.addNum;
        CGFloat num = (100-self.list.disc.floatValue+self.addNum.floatValue)/100.0;
        if (self.dollarShow) {
            self.temp4Label.text = @"汇　　率：";
            self.rateTF.text = [NSString stringWithFormat:@"%.2f", self.rate.floatValue];
            self.temp5Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num)];
            self.temp6Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num*self.list.dSize.floatValue)];
        } else {
            self.temp4Label.text = [NSString stringWithFormat:@"RMB/Ct： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num)];
            self.temp5Label.text = [NSString stringWithFormat:@"RMB/粒： ¥%.2f", round(self.list.rap.floatValue*self.rate.floatValue*num*self.list.dSize.floatValue)];
        }
    } else if (type == 2) {
        if (self.fancyRapShow) {
            self.temp1Label.text = [NSString stringWithFormat:@"　　$/Ct：%.2f", self.list.rap.floatValue];
            self.temp2Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
            NSString *certNo = formatString(self.list.certNo);
            NSString *temp3 = [NSString stringWithFormat:@"　证书号：%@", self.certShow?certNo:@"-"];
            NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc] initWithString:temp3];
            [attr3 addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, temp3.length)];
            if (self.certShow && kStringIsNotEmpty(certNo) && ![certNo isEqualToString:@"-"]) {
                [attr3 addAttribute:NSLinkAttributeName value:@"lookcert://" range:NSMakeRange(5,certNo.length)];
            }
            self.temp3Label.attributedText = attr3;
            self.temp4Label.text = [NSString stringWithFormat:@"证书机构：%@", formatString(self.list.cert)];
            if (kStringIsNotEmpty(self.list.m1) && kStringIsNotEmpty(self.list.m2) && kStringIsNotEmpty(self.list.m3)) {
                self.temp5Label.text = [NSString stringWithFormat:@"尺　　寸：%@ x %@ x %@", self.list.m1, self.list.m2, self.list.m3];
            } else {
                self.temp5Label.text = @"尺　　寸：-";
            }
            self.temp6Label.text = [NSString stringWithFormat:@"　原货号：%@", formatString(self.list.dRef)];
            self.temp7Label.text = [NSString stringWithFormat:@" RMB/Ct： %.2f", self.list.rap.floatValue * self.list.dollarRate.floatValue];
            self.temp8Label.text = [NSString stringWithFormat:@" RMB/粒： %.2f", self.list.rate.floatValue * self.list.dollarRate.floatValue];
        } else {
            self.temp1Label.text = [NSString stringWithFormat:@"克　　拉：%.2f", self.list.dSize.floatValue];
            NSString *certNo = formatString(self.list.certNo);
            NSString *temp2 = [NSString stringWithFormat:@"　证书号：%@", self.certShow?certNo:@"-"];
            NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:temp2];
            [attr2 addAttribute:NSFontAttributeName value:kFont(14) range:NSMakeRange(0, temp2.length)];
            if (self.certShow && kStringIsNotEmpty(certNo) && ![certNo isEqualToString:@"-"]) {
                [attr2 addAttribute:NSLinkAttributeName value:@"lookcert://" range:NSMakeRange(5,certNo.length)];
            }
            self.temp2Label.attributedText = attr2;
            self.temp3Label.text = [NSString stringWithFormat:@"证书机构：%@", formatString(self.list.cert)];
            if (kStringIsNotEmpty(self.list.m1) && kStringIsNotEmpty(self.list.m2) && kStringIsNotEmpty(self.list.m3)) {
                self.temp4Label.text = [NSString stringWithFormat:@"尺　　寸：%@ x %@ x %@", self.list.m1, self.list.m2, self.list.m3];
            } else {
                self.temp4Label.text = @"尺　　寸：-";
            }
            self.temp5Label.text = [NSString stringWithFormat:@"　原货号：%@", formatString(self.list.dRef)];
            self.temp6Label.text = [NSString stringWithFormat:@" RMB/Ct： %.2f", self.list.rap.floatValue * self.list.dollarRate.floatValue];
            self.temp7Label.text = [NSString stringWithFormat:@" RMB/粒： %.2f", self.list.rate.floatValue * self.list.dollarRate.floatValue];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [self.clickSub sendNext:[RACTuple tupleWithObjects:@(2), @(self.index), nil]];
    return YES;
}

- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
    self.selectTag = 1;
    self.selectBtns = [NSMutableArray array];
    self.lines = [NSMutableArray array];
    self.addNum = @"0.00";
    self.fancyRapShow = [SingleInstance boolForKey:FancyRapKey];
    self.dollarShow = [SingleInstance boolForKey:DollarShowKey] && ![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.zuanshi.hk"];
    self.certShow = [SingleInstance boolForKey:CertShowKey];
}

- (void)_setupSubviews {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = kHexColor(@"#B2B2B2").CGColor;
    self.contentView = contentView;
    [self addSubview:contentView];
    
    if (self.fancyRapShow) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"报价信息" forState:UIControlStateNormal];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(12)];
        btn.tag = 1;
        [contentView addSubview:btn];
        [self.selectBtns addObject:btn];
    }
    ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"成本信息" forState:UIControlStateNormal];
    [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [btn.titleLabel setFont:kFont(12)];
    btn.tag = 2;
    [contentView addSubview:btn];
    [self.selectBtns addObject:btn];
    
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
    
    UITextView *temp4Label = [[UITextView alloc] init];
    temp4Label.editable = NO;
    temp4Label.scrollEnabled = NO;
    temp4Label.delegate = self;
    temp4Label.textColor = kHexColor(@"#1C2B36");
    temp4Label.font = kFont(14);
    self.temp4Label = temp4Label;
    [contentView addSubview:temp4Label];
    
    if (self.dollarShow) {
        UITextField *rateTF = [[UITextField alloc] init];
        rateTF.layer.borderColor = COLOR_LINE.CGColor;
        rateTF.layer.borderWidth = 1;
        rateTF.font = kFont(15);
        rateTF.textColor = kHexColor(@"#1C2B36");
        rateTF.keyboardType = UIKeyboardTypeDecimalPad;
        rateTF.textAlignment = NSTextAlignmentCenter;
        self.rateTF = rateTF;
        [contentView addSubview:rateTF];
    }
    
    UITextView *temp5Label = [[UITextView alloc] init];
    temp5Label.editable = NO;
    temp5Label.scrollEnabled = NO;
    temp5Label.delegate = self;
    temp5Label.textColor = kHexColor(@"#1C2B36");
    temp5Label.font = kFont(14);
    self.temp5Label = temp5Label;
    [contentView addSubview:temp5Label];
    
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
        make.top.mas_equalTo(self.temp3Label).offset(ZGCConvertToPx(5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(82));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-78));
        make.bottom.mas_equalTo(self.temp3Label.mas_bottom).offset(ZGCConvertToPx(-5));
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.addTF);
        make.width.mas_equalTo(ZGCConvertToPx(37.5));
    }];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.addTF);
        make.width.mas_equalTo(ZGCConvertToPx(37.5));
    }];
    [self.temp4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
    }];
    if (self.dollarShow) {
        [self.rateTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.temp4Label);
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(82));
            make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-150));
            make.height.mas_equalTo(self.temp4Label);
        }];
    }
    [self.temp5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp4Label.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(7.5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-7.5));
        make.height.mas_equalTo(ZGCConvertToPx(28));
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
    if (self.dollarShow) self.rateTF.hidden = btn.tag!=1;
    self.quoteBtn.hidden = btn.tag!=1;
    [self.temp3Label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZGCConvertToPx(btn.tag==1?42:28));
    }];
    if (self.dollarShow) {
        [self.temp4Label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ZGCConvertToPx(btn.tag==1?32:28));
        }];
    }
}

- (void)_bind {
    if (self.dollarShow) RACChannelTo(self, rate) = self.rateTF.rac_newTextChannel;
    RACChannelTo(self, addNum) = self.addTF.rac_newTextChannel;
    [RACObserve(self, addNum) subscribeNext:^(id  _Nullable x) {
        [self updateContent:1];
    }];
}


@end
