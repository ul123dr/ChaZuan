//
//  OrderCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell ()

@property (nonatomic, readwrite, strong) OrderItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) UIImageView *goodImageView;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *numLabel;
@property (nonatomic, readwrite, strong) UILabel *tempLabel1;
@property (nonatomic, readwrite, strong) UILabel *tempLabel2;
@property (nonatomic, readwrite, strong) UILabel *tempLabel3;
@property (nonatomic, readwrite, strong) UILabel *tempLabel4;
@property (nonatomic, readwrite, strong) UILabel *tempLabel5;
@property (nonatomic, readwrite, strong) UILabel *tempLabel6;
@property (nonatomic, readwrite, strong) UILabel *tempLabel7;
@property (nonatomic, readwrite, strong) UILabel *tempLabel8;
@property (nonatomic, readwrite, strong) UILabel *tempLabel9;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation OrderCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(OrderItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [[RACObserve(viewModel, img) ignore:nil] subscribeNext:^(NSString *imgUrl) {
        @strongify(self);
        if ([imgUrl hasPrefix:@"http"])
            [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        else
            self.goodImageView.image = ImageNamed(imgUrl);
    }];
    [[RACObserve(viewModel, price) ignore:nil] subscribeNext:^(NSNumber *price) {
        @strongify(self);
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", price.floatValue];
    }];
    RAC(self.tempLabel1, text) = [RACObserve(viewModel, temp1) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel2, text) = [RACObserve(viewModel, temp2) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel3, text) = [RACObserve(viewModel, temp3) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel4, text) = [RACObserve(viewModel, temp4) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel5, text) = [RACObserve(viewModel, temp5) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel6, text) = [RACObserve(viewModel, temp6) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel7, text) = [RACObserve(viewModel, temp7) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel8, text) = [RACObserve(viewModel, temp8) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.tempLabel9, text) = [RACObserve(viewModel, temp9) takeUntil:self.rac_prepareForReuseSignal];
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
    self.contentView.backgroundColor = kHexColor(@"#EDF1F2");
}

- (void)_setupSubviews {
    UIImageView *goodImageView = [[UIImageView alloc] init];
    goodImageView.backgroundColor = UIColor.whiteColor;
    goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.goodImageView = goodImageView;
    [self.contentView addSubview:goodImageView];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = kHexColor(@"#f85359");
    priceLabel.font = kFont(12);
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    UILabel *tempLabel1 = [[UILabel alloc] init];
    tempLabel1.textColor = kHexColor(@"#1C2B36");
    tempLabel1.font = kFont(12);
    self.tempLabel1 = tempLabel1;
    [self.contentView addSubview:tempLabel1];
    
    UILabel *tempLabel2 = [[UILabel alloc] init];
    tempLabel2.textColor = kHexColor(@"#1C2B36");
    tempLabel2.font = kFont(12);
    self.tempLabel2 = tempLabel2;
    [self.contentView addSubview:tempLabel2];
    
    UILabel *tempLabel3 = [[UILabel alloc] init];
    tempLabel3.textColor = kHexColor(@"#1C2B36");
    tempLabel3.font = kFont(12);
    self.tempLabel3 = tempLabel3;
    [self.contentView addSubview:tempLabel3];
    
    UILabel *tempLabel4 = [[UILabel alloc] init];
    tempLabel4.textColor = kHexColor(@"#1C2B36");
    tempLabel4.font = kFont(12);
    self.tempLabel4 = tempLabel4;
    [self.contentView addSubview:tempLabel4];
    
    UILabel *tempLabel5 = [[UILabel alloc] init];
    tempLabel5.textColor = kHexColor(@"#1C2B36");
    tempLabel5.font = kFont(12);
    self.tempLabel5 = tempLabel5;
    [self.contentView addSubview:tempLabel5];
    
    UILabel *tempLabel6 = [[UILabel alloc] init];
    tempLabel6.textColor = kHexColor(@"#1C2B36");
    tempLabel6.font = kFont(12);
    self.tempLabel6 = tempLabel6;
    [self.contentView addSubview:tempLabel6];
    
    UILabel *tempLabel7 = [[UILabel alloc] init];
    tempLabel7.textColor = kHexColor(@"#1C2B36");
    tempLabel7.font = kFont(12);
    self.tempLabel7 = tempLabel7;
    [self.contentView addSubview:tempLabel7];
    
    UILabel *tempLabel8 = [[UILabel alloc] init];
    tempLabel8.textColor = kHexColor(@"#1C2B36");
    tempLabel8.font = kFont(12);
    self.tempLabel8 = tempLabel8;
    [self.contentView addSubview:tempLabel8];
    
    UILabel *tempLabel9 = [[UILabel alloc] init];
    tempLabel9.textColor = kHexColor(@"#1C2B36");
    tempLabel9.font = kFont(12);
    self.tempLabel9 = tempLabel9;
    [self.contentView addSubview:tempLabel9];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = kHexColor(@"#0E67F4");
    numLabel.font = kFont(12);
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.text = @"x 1";
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = kHexColor(@"#D4D9DB");
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.width.height.mas_equalTo(ZGCConvertToPx(90));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel1.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel2.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel3.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel4.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel5.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel6.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel7.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.self.tempLabel8.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-31));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-16));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

@end
