//
//  PopGoodCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/2.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PopGoodCell.h"

@implementation PopGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)bindModel:(StyleDetailList *)list type:(StyleType)type {
    if (type == StyleGoodsList) {
        NSString *temp1 = list.designNo;
        if (kStringIsNotEmpty(list.temp1)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.temp1];
        if (kStringIsNotEmpty(list.materialCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.materialCn];
        temp1 = [temp1 stringByAppendingFormat:@"；总件重：%@", validateString(list.weight)];
        if (list.weight.floatValue > 0) temp1 = [temp1 stringByAppendingString:@"g"];
        self.temp1Label.text = [temp1 stringByAppendingString:@"；"];
        
        NSString *temp3 = [NSString stringWithFormat:@"主石大小：%@", validateString(list.size)];
        if (list.size.floatValue > 0) temp3 = [temp3 stringByAppendingString:@"ct"];
        temp3 = [temp3 stringByAppendingFormat:@"； 手寸：%@；", formatString(list.dHand)];
        self.temp3Label.text = temp3;
        
        self.temp4Label.text = [NSString stringWithFormat:@"主石类别：%@；主石形状：%@；", formatString(list.temp4), formatString(list.sizeShapeCn)];
        self.temp5Label.text = [NSString stringWithFormat:@"主石级别：%@；", formatString(list.sizeShapeLevel)];
        self.temp6Label.text = [NSString stringWithFormat:@"副石粒数：%@；副石重：%@ct；", formatString(list.sideStoneNum), formatString(list.sideStoneSize)];
        self.temp7Label.text = [NSString stringWithFormat:@"副石描述：%@；", formatString(list.sideStoneRemark)];
        self.temp8Label.text = [NSString stringWithFormat:@"证书：%@　%@；", formatString(list.cert), validateString(list.certNo)];
        self.statusLabel.text = [NSString stringWithFormat:@"状态：%@；",  validateString([list.status.stringValue zgc_parseInt]==0?@"在售":@"借出")];
    } else {
        NSString *temp1 = list.zsmc;
        if (kStringIsNotEmpty(list.designTypeCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.designTypeCn];
        if (kStringIsNotEmpty(list.materialTypeCn)) temp1 = [temp1 stringByAppendingFormat:@"-%@", list.materialTypeCn];
        temp1 = [temp1 stringByAppendingFormat:@"；总件重：%@", validateString(list.weight)];
        if (list.weight.floatValue > 0) temp1 = [temp1 stringByAppendingString:@"g"];
        self.temp1Label.text = [temp1 stringByAppendingString:@"；"];
        
        NSString *temp3 = [NSString stringWithFormat:@"主石：%@", formatString(list.size)];
        if (list.size.floatValue > 0) temp3 = [temp3 stringByAppendingString:@"ct"];
        temp3 = [temp3 stringByAppendingFormat:@"； 手寸：%@#；", validateString(list.hand)];
        self.temp3Label.text = temp3;
    }
    
    NSString *temp2 = [NSString stringWithFormat:@"条码：%@；净金重：%@", formatString(list.barCode), formatString(list.materialWeight)];
    if (list.materialWeight.floatValue > 0) temp2 = [temp2 stringByAppendingString:@"g"];
    self.temp2Label.text = [temp2 stringByAppendingString:@"；"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",list.price.floatValue];
    self.clickBtn.enabled = YES;
    self.clickBtn.layer.borderColor = kHexColor(@"#3882FF").CGColor;
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)doSelectCell {
    self.clickBtn.enabled = NO;
    self.clickBtn.layer.borderColor = kHexColor(@"#CCCCCC").CGColor;
    self.contentView.backgroundColor = kHexColor(@"#F1F1F1");
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
    self.contentView.backgroundColor = UIColor.whiteColor;
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
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = kHexColor(@"#020D2C");
    statusLabel.font = kBoldFont(13);
    self.statusLabel = statusLabel;
    [self.contentView addSubview:statusLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = kHexColor(@"#F85359");
    priceLabel.font = kBoldFont(16);
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    ZGButton *clickBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    clickBtn.layer.cornerRadius = ZGCConvertToPx(15);
    clickBtn.clipsToBounds = YES;
    clickBtn.layer.borderColor = kHexColor(@"#3882FF").CGColor;
    clickBtn.layer.borderWidth = 1;
    [clickBtn setTitle:@"添加" forState:UIControlStateNormal];
    [clickBtn setTitleColor:kHexColor(@"#3882FF") forState:UIControlStateNormal];
    [clickBtn setTitle:@"已选" forState:UIControlStateDisabled];
    [clickBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
    [clickBtn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
    [clickBtn setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#CCCCCC")] forState:UIControlStateDisabled];
    [clickBtn.titleLabel setFont:kBoldFont(13)];
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.temp1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(16.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp1Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp2Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp4Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp5Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp6Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.temp8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp7Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp8Label.mas_bottom).offset(ZGCConvertToPx(1.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(12.5));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
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
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
@end
