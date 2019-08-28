//
//  StyleTableViewCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleTableViewCell.h"

@interface GoodButton : ZGButton

- (void)setProductModel:(StyleType)type model:(DiamondList *)model;

@property (nonatomic, readwrite, strong) UIImageView *imageIcon;
@property (nonatomic, readwrite, strong) UILabel *temp1;
@property (nonatomic, readwrite, strong) UILabel *temp2;
@property (nonatomic, readwrite, strong) UILabel *temp3;
@property (nonatomic, readwrite, strong) UILabel *temp4;
@property (nonatomic, readwrite, strong) UILabel *temp5;
@property (nonatomic, readwrite, strong) UILabel *temp6;

@end

@implementation GoodButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)setProductModel:(StyleType)type model:(DiamondList *)model {
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:[self _fetchImageName:model]]];
    
    if (type == StyleCenter) {
        self.temp2.text = [NSString stringWithFormat:@"款号：%@", formatString(model.designNo)];
        self.temp3.text = [NSString stringWithFormat:@"主石：%@ct", formatString(model.size)];
        self.temp4.text = [NSString stringWithFormat:@"副石：%@", formatString(model.sideStone)];
    } else if (type == StyleGoodsList) {
        self.temp3.text = [NSString stringWithFormat:@"款号：%@", formatString(model.designNo)];
        self.temp5.text = [NSString stringWithFormat:@"￥%@", model.priceMin];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"库存%@", model.stockNum]];
        [str addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#FF9000") range:NSMakeRange(2, model.stockNum.stringValue.length)];
        self.temp6.attributedText = str;
    } else {
        self.temp1.text = model.goodsName;
        self.temp2.text = [NSString stringWithFormat:@"款号：%@", formatString(model.designNo)];
        self.temp3.text = [NSString stringWithFormat:@"主石：%@ct", formatString(model.size)];
        self.temp4.text = [NSString stringWithFormat:@"副石：%@", formatString(model.sideStone)];
        self.temp5.text = [NSString stringWithFormat:@"￥%@", model.price];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"库存%@", model.stockNum]];
        [str addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#FF9000") range:NSMakeRange(2, model.stockNum.stringValue.length)];
        self.temp6.attributedText = str;
    }
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)_setupSubviews {
    UIImageView *imageIcon = [[UIImageView alloc] init];
    imageIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.imageIcon = imageIcon;
    [self addSubview:imageIcon];
    
    UILabel *temp1 = [[UILabel alloc] init];
    temp1.textColor = kHexColor(@"#1C2B36");
    temp1.font = kFont(12);
    self.temp1 = temp1;
    [self addSubview:temp1];
    
    UILabel *temp2 = [[UILabel alloc] init];
    temp2.textColor = kHexColor(@"#1C2B36");
    temp2.font = kFont(12);
    self.temp2 = temp2;
    [self addSubview:temp2];
    
    UILabel *temp3 = [[UILabel alloc] init];
    temp3.textColor = kHexColor(@"#1C2B36");
    temp3.font = kFont(12);
    self.temp3 = temp3;
    [self addSubview:temp3];
    
    UILabel *temp4 = [[UILabel alloc] init];
    temp4.textColor = kHexColor(@"#1C2B36");
    temp4.font = kFont(12);
    self.temp4 = temp4;
    [self addSubview:temp4];
    
    UILabel *temp5 = [[UILabel alloc] init];
    temp5.textColor = kHexColor(@"#F85359");
    temp5.font = kFont(12);
    temp5.textAlignment = NSTextAlignmentRight;
    self.temp5 = temp5;
    [self addSubview:temp5];
    
    UILabel *temp6 = [[UILabel alloc] init];
    temp6.textColor = kHexColor(@"#1C2B36");
    temp6.font = kFont(12);
    temp6.textAlignment = NSTextAlignmentRight;
    self.temp6 = temp6;
    [self addSubview:temp6];
}

- (void)_setupSubviewsConstraint {
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(self.imageIcon.mas_width);
    }];
    [self.temp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(-ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(20));
    }];
    [self.temp2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp1.mas_bottom);
        make.left.right.height.mas_equalTo(self.temp1);
    }];
    [self.temp3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp2.mas_bottom);
        make.left.right.height.mas_equalTo(self.temp1);
    }];
    [self.temp4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp3.mas_bottom);
        make.left.right.height.mas_equalTo(self.temp1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(ZGCConvertToPx(-6));
    }];
    [self.temp5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.temp1);
    }];
    [self.temp6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temp5.mas_bottom);
        make.left.right.height.mas_equalTo(self.temp1);
        make.bottom.mas_equalTo(self.temp4.mas_bottom);
    }];
}

- (NSString *)_fetchImageName:(DiamondList *)list {
    NSString *name;
    NSArray *picArr = [list.pic componentsSeparatedByString:@","];
    if ([picArr[0] hasPrefix:@"http"]) return picArr[0];
    if (list.source.integerValue == 8) {
        name = [NSString stringWithFormat:@"https://www9.wanttoseeyouagain.com/fileserver/echao_img_temp/%@", picArr[0]];
    } else {
        name = [NSString stringWithFormat:@"http://%@/fileserver/%@", [SingleInstance stringForKey:ZGCUserWwwKey], picArr[0]];
    }
    return name;
}

@end


@interface StyleTableViewCell ()

/// viewModel
@property (nonatomic, readwrite, strong) StyleItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) GoodButton *leftProdBtn;
@property (nonatomic, readwrite, strong) GoodButton *rightProdBtn;

@end

@implementation StyleTableViewCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"StyleTableViewCell";
    StyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(StyleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.leftProdBtn setProductModel:viewModel.type model:viewModel.model[0]];
    self.rightProdBtn.hidden = viewModel.model.count == 1;
    if (viewModel.model.count >= 2)
        [self.rightProdBtn setProductModel:viewModel.type model:viewModel.model[1]];
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
    self.contentView.backgroundColor = COLOR_BG;
}

- (void)_setupSubviews {
    GoodButton *leftProdBtn = [GoodButton buttonWithType:UIButtonTypeCustom];
    self.leftProdBtn = leftProdBtn;
    [self.contentView addSubview:leftProdBtn];
    
    GoodButton *rightProdBtn = [GoodButton buttonWithType:UIButtonTypeCustom];
    self.rightProdBtn = rightProdBtn;
    [self.contentView addSubview:rightProdBtn];
    
    // 点击事件
    @weakify(self);
    [[leftProdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(GoodButton *sender) {
        @strongify(self);
        if (self.viewModel.model.count >= 1)
            [self.viewModel.didSelectCommand execute:self.viewModel.model[0]];
    }];
    [[rightProdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(GoodButton *sender) {
        @strongify(self);
        if (self.viewModel.model.count >= 2)
            [self.viewModel.didSelectCommand execute:self.viewModel.model[1]];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.leftProdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.rightProdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.leftProdBtn.mas_right).offset(ZGCConvertToPx(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.leftProdBtn.mas_width);
    }];
}

@end
