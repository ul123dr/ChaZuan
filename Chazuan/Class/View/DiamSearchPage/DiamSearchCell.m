//
//  DiamSearchCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchCell.h"

@interface DiamSearchCell ()

/// viewModel
@property (nonatomic, readwrite, strong) DiamSearchItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) UILabel *certNoLabel;
@property (nonatomic, readwrite, strong) UITextField *certNoTF;

@property (nonatomic, readwrite, assign) BOOL hasDetail;
@property (nonatomic, readwrite, strong) UILabel *detailLabel;
@property (nonatomic, readwrite, strong) UITextField *detailTF;

@property (nonatomic, readwrite, strong) UILabel *dRefLabel;
@property (nonatomic, readwrite, strong) UITextField *dRefTF;

@property (nonatomic, readwrite, assign) BOOL hasAdd;
@property (nonatomic, readwrite, strong) UILabel *addLabel;
@property (nonatomic, readwrite, strong) UITextField *addTF;
@property (nonatomic, readwrite, strong) ZGButton *addBtn;
@property (nonatomic, readwrite, strong) ZGButton *minusBtn;
@property (nonatomic, readwrite, assign) BOOL hasRate;
@property (nonatomic, readwrite, strong) UILabel *rateLabel;
@property (nonatomic, readwrite, strong) UITextField *rateTF;

@end

@implementation DiamSearchCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DiamSearchCell";
    DiamSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(DiamSearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    RACChannelTo(viewModel, certNo) = self.certNoTF.rac_newTextChannel;
    if (self.hasDetail) {
        RACChannelTo(viewModel, detail) = self.detailTF.rac_newTextChannel;
    }
    RACChannelTo(viewModel, dRef) = self.dRefTF.rac_newTextChannel;
    if (self.hasAdd) {
        self.addTF.text = [NSString stringWithFormat:@"%.2f", viewModel.addNum.floatValue];
        RACChannelTo(viewModel, addNum) = self.addTF.rac_newTextChannel;
        if (self.hasRate) {
            self.rateTF.text = [NSString stringWithFormat:@"%.2f", viewModel.rate.floatValue];
            RACChannelTo(viewModel, rate) = self.rateTF.rac_newTextChannel;
        }
    }
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
    self.hasDetail = SharedAppDelegate.manager.gid.integerValue == 0 && [SingleInstance boolForKey:RapIdShowKey];
    self.hasAdd = [SingleInstance boolForKey:DiscShowKey];
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
    
    if (self.hasDetail) {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = kFont(15);
        detailLabel.textColor = kHexColor(@"#1C2B36");
        detailLabel.text = @"供应商";
        self.detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
        
        UITextField *detailTF = [[UITextField alloc] init];
        detailTF.layer.borderColor = COLOR_LINE.CGColor;
        detailTF.layer.borderWidth = 1;
        detailTF.keyboardType = UIKeyboardTypeDecimalPad;
        detailTF.font = kFont(15);
        detailTF.textColor = kHexColor(@"#1C2B36");
        detailTF.leftViewMode = UITextFieldViewModeAlways;
        detailTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 0)];
        self.detailTF = detailTF;
        [self.contentView addSubview:detailTF];
    }
    
    UILabel *dRefLabel = [[UILabel alloc] init];
    dRefLabel.font = kFont(15);
    dRefLabel.textColor = kHexColor(@"#1C2B36");
    dRefLabel.text = @"货号";
    self.dRefLabel = dRefLabel;
    [self.contentView addSubview:dRefLabel];
    
    UITextField *dRefTF = [[UITextField alloc] init];
    dRefTF.layer.borderColor = COLOR_LINE.CGColor;
    dRefTF.layer.borderWidth = 1;
    dRefTF.font = kFont(15);
    dRefTF.textColor = kHexColor(@"#1C2B36");
    dRefTF.leftViewMode = UITextFieldViewModeAlways;
    dRefTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 0)];
    self.dRefTF = dRefTF;
    [self.contentView addSubview:dRefTF];

    if (self.hasAdd) {
        UILabel *addLabel = [[UILabel alloc] init];
        addLabel.font = kFont(15);
        addLabel.textColor = kHexColor(@"#1C2B36");
        addLabel.text = @"加点";
        self.addLabel = addLabel;
        [self.contentView addSubview:addLabel];
        
        UITextField *addTF = [[UITextField alloc] init];
        addTF.layer.borderColor = COLOR_LINE.CGColor;
        addTF.layer.borderWidth = 1;
        addTF.font = kFont(15);
        addTF.textColor = kHexColor(@"#1C2B36");
        addTF.keyboardType = UIKeyboardTypeDecimalPad;
        addTF.textAlignment = NSTextAlignmentCenter;
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
    if (self.hasDetail) {
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certNoLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
        [self.detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailLabel);
            make.left.mas_equalTo(self.certNoLabel.mas_right);
            make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            make.height.mas_equalTo(self.certNoLabel);
        }];
        
        [self.dRefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
        [self.dRefTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dRefLabel);
            make.left.mas_equalTo(self.certNoLabel.mas_right);
            make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            make.height.mas_equalTo(self.certNoLabel);
        }];
    } else {
        [self.dRefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certNoLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
        }];
        [self.dRefTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dRefLabel);
            make.left.mas_equalTo(self.certNoLabel.mas_right);
            make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
            make.height.mas_equalTo(self.certNoLabel);
        }];
    }
    
    if (self.hasAdd) {
        [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dRefLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
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
    } else {
        [self.dRefLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.certNoLabel.mas_bottom).offset(ZGCConvertToPx(10));
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
            make.size.mas_equalTo(self.certNoLabel);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-10));
        }];
    }
}

@end
