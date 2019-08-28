//
//  FancySearchCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancySearchCell.h"

@interface FancySearchCell ()

/// viewModel
@property (nonatomic, readwrite, strong) FancySearchItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) UILabel *certNoLabel;
@property (nonatomic, readwrite, strong) UITextField *certNoTF;

@property (nonatomic, readwrite, assign) BOOL hasAdd;
@property (nonatomic, readwrite, strong) UILabel *addLabel;
@property (nonatomic, readwrite, strong) UITextField *addTF;
@property (nonatomic, readwrite, strong) ZGButton *addBtn;
@property (nonatomic, readwrite, strong) ZGButton *minusBtn;
@property (nonatomic, readwrite, assign) BOOL hasRate;
@property (nonatomic, readwrite, strong) UILabel *rateLabel;
@property (nonatomic, readwrite, strong) UITextField *rateTF;

@property (nonatomic, readwrite, strong) UILabel *sizeLabel;
@property (nonatomic, readwrite, strong) UITextField *sizeField1;
@property (nonatomic, readwrite, strong) UILabel *sepLabel;
@property (nonatomic, readwrite, strong) UITextField *sizeField2;
@property (nonatomic, readwrite, strong) ZGButton *sizeBtn;

@property (nonatomic, readwrite, strong) UILabel *certLabel;
@property (nonatomic, readwrite, strong) ZGButton *certBtn;

@end

@implementation FancySearchCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"FancySearchCell";
    FancySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(FancySearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    RACChannelTo(viewModel, certNo) = self.certNoTF.rac_newTextChannel;
    if (self.hasAdd) {
        self.addTF.text = [NSString stringWithFormat:@"%.2f", viewModel.addNum.floatValue];
        RACChannelTo(viewModel, addNum) = self.addTF.rac_newTextChannel;
        if (self.hasRate) {
            self.rateTF.text = [NSString stringWithFormat:@"%.2f", viewModel.rate.floatValue];
            RACChannelTo(viewModel, rate) = self.rateTF.rac_newTextChannel;
        }
    }
    @weakify(self);
    [[RACObserve(viewModel, sizeBtnTitle) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *btnTitle) {
        @strongify(self);
        [self.sizeBtn setTitle:btnTitle forState:UIControlStateNormal];
    }];
    RAC(self.sizeField1, text) = [RACObserve(viewModel, sizeMin) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.sizeField2, text) = [RACObserve(viewModel, sizeMax) takeUntil:self.rac_prepareForReuseSignal];
    
    [[RACObserve(viewModel, certBtnTitle) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *btnTitle) {
        @strongify(self);
        [self.certBtn setTitle:btnTitle forState:UIControlStateNormal];
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
    self.hasAdd = [SingleInstance boolForKey:FancyRapKey];
    self.hasRate = ![[SingleInstance stringForKey:ZGCUserWwwKey] isEqualToString:@"www.zuanshi.hk"] && [SingleInstance boolForKey:DollarShowKey];
}

- (void)_setupSubviews {
    UILabel *certNoLabel = [[UILabel alloc] init];
    certNoLabel.font = kFont(15);
    certNoLabel.textColor = kHexColor(@"#1C2B36");
    certNoLabel.text = @"证书编号";
    self.certNoLabel = certNoLabel;
    [self.contentView addSubview:certNoLabel];
    
    UITextField *certNoTF = [[UITextField alloc] init];
    certNoTF.layer.borderColor = COLOR_LINE.CGColor;
    certNoTF.layer.borderWidth = 1;
    certNoTF.keyboardType = UIKeyboardTypeDecimalPad;
    certNoTF.font = kFont(15);
    certNoTF.textColor = kHexColor(@"#1C2B36");
    certNoTF.leftViewMode = UITextFieldViewModeAlways;
    certNoTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 0)];
    self.certNoTF = certNoTF;
    [self.contentView addSubview:certNoTF];
    
    if (self.hasAdd) {
        UILabel *addLabel = [[UILabel alloc] init];
        addLabel.font = kFont(15);
        addLabel.textColor = kHexColor(@"#1C2B36");
        addLabel.text = @"倍率";
        self.addLabel = addLabel;
        [self.contentView addSubview:addLabel];
        
        UITextField *addTF = [[UITextField alloc] init];
        addTF.layer.borderColor = COLOR_LINE.CGColor;
        addTF.layer.borderWidth = 1;
        addTF.font = kFont(15);
        addTF.textColor = kHexColor(@"#1C2B36");
        addTF.keyboardType = UIKeyboardTypeDecimalPad;
        addTF.textAlignment = NSTextAlignmentCenter;
        addTF.text = @"1.00";
        self.addTF = addTF;
        [self.contentView addSubview:addTF];
        
        ZGButton *leftBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:ImageNamed(@"disc_add") forState:UIControlStateNormal];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(11), ZGCConvertToPx(9.375), ZGCConvertToPx(11), ZGCConvertToPx(9.375));
        [addTF addSubview:leftBtn];
        self.addBtn = leftBtn;
        
        ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:ImageNamed(@"disc_remove") forState:UIControlStateNormal];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(11), ZGCConvertToPx(9.375), ZGCConvertToPx(11), ZGCConvertToPx(9.375));
        [addTF addSubview:rightBtn];
        self.minusBtn = rightBtn;
        
        @weakify(self);
        [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            CGFloat addNum = self.addTF.text.floatValue;
            addNum ++;
            self.addTF.text = [NSString stringWithFormat:@"%.2f", addNum];
            self.viewModel.addNum = self.addTF.text;
        }];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            CGFloat minusNum = self.addTF.text.floatValue;
            minusNum = minusNum -- < 1 ? 0 : minusNum;
            self.addTF.text = [NSString stringWithFormat:@"%.2f", minusNum];
            self.viewModel.addNum = self.addTF.text;
        }];
        
        if (self.hasRate) {
            UILabel *rateLabel = [[UILabel alloc] init];
            rateLabel.font = kFont(15);
            rateLabel.textColor = kHexColor(@"#1C2B36");
            rateLabel.text = @"汇率";
            self.rateLabel = rateLabel;
            [self.contentView addSubview:rateLabel];
            
            UITextField *rateTF = [[UITextField alloc] init];
            rateTF.layer.borderColor = COLOR_LINE.CGColor;
            rateTF.layer.borderWidth = 1;
            rateTF.font = kFont(15);
            rateTF.textColor = kHexColor(@"#1C2B36");
            rateTF.keyboardType = UIKeyboardTypeDecimalPad;
            rateTF.textAlignment = NSTextAlignmentCenter;
            self.rateTF = rateTF;
            [self.contentView addSubview:rateTF];
        }
    }
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textColor = kHexColor(@"#1C2B36");
    sizeLabel.font = kFont(15);
    sizeLabel.text = @"克拉";
    self.sizeLabel = sizeLabel;
    [self.contentView addSubview:sizeLabel];
    
    UITextField *sizeField1 = [[UITextField alloc] init];
    sizeField1.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    sizeField1.layer.borderWidth = 1;
    sizeField1.layer.cornerRadius = 2;
    sizeField1.font = kFont(15);
    sizeField1.textColor = kHexColor(@"#333333");
    sizeField1.textAlignment = NSTextAlignmentCenter;
    sizeField1.keyboardType = UIKeyboardTypeDecimalPad;
    self.sizeField1 = sizeField1;
    [self.contentView addSubview:sizeField1];
    
    UILabel *sepLabel = [[UILabel alloc] init];
    sepLabel.textColor = kHexColor(@"#1C2B36");
    sepLabel.font = kBoldFont(15);
    sepLabel.text = @"~";
    sepLabel.textAlignment = NSTextAlignmentCenter;
    self.sepLabel = sepLabel;
    [self.contentView addSubview:sepLabel];
    
    UITextField *sizeField2 = [[UITextField alloc] init];
    sizeField2.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    sizeField2.layer.borderWidth = 1;
    sizeField2.layer.cornerRadius = 2;
    sizeField2.font = kFont(15);
    sizeField2.textColor = kHexColor(@"#333333");
    sizeField2.textAlignment = NSTextAlignmentCenter;
    sizeField2.keyboardType = UIKeyboardTypeDecimalPad;
    self.sizeField2 = sizeField2;
    [self.contentView addSubview:sizeField2];
    
    ZGButton *sizeBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    sizeBtn.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    sizeBtn.layer.borderWidth = 1;
    sizeBtn.layer.cornerRadius = 2;
    [sizeBtn.titleLabel setFont:kFont(15)];
    [sizeBtn setTitleColor:kHexColor(@"#333333") forState:UIControlStateNormal];
    self.sizeBtn = sizeBtn;
    [self.contentView addSubview:sizeBtn];
    
    @weakify(self);
    [[sizeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.sizeSub sendNext:sender];
    }];
    
    UILabel *certLabel = [[UILabel alloc] init];
    certLabel.textColor = kHexColor(@"#1C2B36");
    certLabel.font = kFont(15);
    certLabel.text = @"证书机构";
    self.certLabel = certLabel;
    [self.contentView addSubview:certLabel];
    
    ZGButton *certBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    certBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    certBtn.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    certBtn.layer.borderWidth = 1;
    certBtn.layer.cornerRadius = 2;
    [certBtn.titleLabel setFont:kBoldFont(12)];
    [certBtn setTitleColor:kHexColor(@"#333333") forState:UIControlStateNormal];
    [certBtn setImage:ImageNamed(@"select_bottom") forState:UIControlStateNormal];
    self.certBtn = certBtn;
    [self.contentView addSubview:certBtn];
    [certBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -ZGCConvertToPx(32), 0, ZGCConvertToPx(32))];
    [certBtn setImageEdgeInsets:UIEdgeInsetsMake(ZGCConvertToPx(21.5), ZGCConvertToPx(240), ZGCConvertToPx(21.5), -ZGCConvertToPx(20))];
    
    [[certBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.certSub sendNext:sender];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.certNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.width.mas_equalTo(ZGCConvertToPx(70));
    }];
    [self.certNoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.certNoLabel.mas_right);
        make.top.mas_equalTo(self.certNoLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.certNoLabel);
    }];
    
    if (self.hasAdd) {
        [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certNoLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
        if (self.hasRate) {
            [self.addTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.addLabel);
                make.left.mas_equalTo(self.certNoLabel.mas_right);
                make.height.mas_equalTo(self.certNoLabel);
            }];
            
            [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.addTF.mas_right).offset(ZGCConvertToPx(10));
                make.top.mas_equalTo(self.addTF);
                make.height.mas_equalTo(self.addTF);
                make.width.mas_equalTo(self.addTF).multipliedBy(0.2);
            }];
            [self.rateTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.rateLabel.mas_right).offset(ZGCConvertToPx(5));
                make.top.mas_equalTo(self.rateLabel);
                make.height.mas_equalTo(self.rateLabel);
                make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
                make.width.mas_equalTo(self.addTF).multipliedBy(0.314);
            }];
        } else {
            [self.addTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.addLabel);
                make.left.mas_equalTo(self.certNoLabel.mas_right);
                make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
                make.height.mas_equalTo(self.certNoLabel);
            }];
        }
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self.addTF);
            make.width.mas_equalTo(ZGCConvertToPx(37.5));
        }];
        
        [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self.addTF);
            make.width.mas_equalTo(ZGCConvertToPx(37.5));
        }];
        
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
    } else {
        [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certNoLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
    }
    
    [self.sizeField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.width.mas_equalTo(self.sizeLabel).multipliedBy(1.1);
        make.height.mas_equalTo(self.certNoLabel);
    }];
    [self.sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sizeField1.mas_right);
        make.width.mas_equalTo(self.sizeField1).multipliedBy(1.0/3);
        make.height.mas_equalTo(self.certNoLabel);
    }];
    [self.sizeField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sepLabel.mas_right);
        make.width.mas_equalTo(self.sizeField1);
        make.height.mas_equalTo(self.certNoLabel);
    }];
    [self.sizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sizeField2.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.sizeField1);
        make.height.mas_equalTo(self.certNoLabel);
    }];
    
    [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel.mas_bottom).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.size.mas_equalTo(self.certNoLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
    }];
    [self.certBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.certLabel.mas_right);
        make.top.mas_equalTo(self.certLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.certNoLabel);
    }];
}

@end
