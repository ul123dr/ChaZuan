//
//  ShopCartCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopCartCell.h"

@interface ShopCartCell ()

@property (nonatomic, readwrite, strong) CartItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIView *containView;
@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) UILabel *typeLabel;
@property (nonatomic, readwrite, strong) UILabel *saleLabel;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@property (nonatomic, readwrite, strong) UIImageView *goodImageView;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *tempLabel1;
@property (nonatomic, readwrite, strong) UILabel *tempLabel2;
@property (nonatomic, readwrite, strong) UILabel *tempLabel3;
@property (nonatomic, readwrite, strong) UILabel *tempLabel4;
@property (nonatomic, readwrite, strong) UILabel *tempLabel5;
@property (nonatomic, readwrite, strong) UILabel *tempLabel6;
@property (nonatomic, readwrite, strong) UILabel *tempLabel7;
@property (nonatomic, readwrite, strong) UILabel *tempLabel8;
@property (nonatomic, readwrite, strong) UILabel *tempLabel9;

@end

@implementation ShopCartCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"ShopCartCell";
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CartItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(viewModel, type) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        NSString *txt;
        switch (x.integerValue) {
            case 0:
                txt = @"类型：白钻";
                break;
            case 4:
                txt = @"类型：彩钻";
                break;
            case 5:
                txt = @"类型：款式";
                break;
            case 8:
                txt = @"类型：现货";
                break;
            default:
                txt = @"类型：-";
                break;
        }
        self.typeLabel.text = txt;
    }];
    [RACObserve(viewModel, canSale) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.saleLabel.text = x.boolValue?@"可售":@"不可售";
    }];
    [RACObserve(viewModel, img) subscribeNext:^(NSString *imgUrl) {
        @strongify(self);
        if ([imgUrl hasPrefix:@"http"])
            [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        else
            self.goodImageView.image = ImageNamed(imgUrl);
    }];
    [RACObserve(viewModel, price) subscribeNext:^(NSNumber *price) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", price.floatValue];
    }];
    RAC(self.selectBtn, selected) = [RACObserve(viewModel, selected) takeUntil:self.rac_prepareForReuseSignal];
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
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = UIColor.whiteColor;
    self.containView = containView;
    [self.contentView addSubview:containView];
    
    ZGButton *selectBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:ImageNamed(@"checkbox_nor") forState:UIControlStateNormal];
    [selectBtn setImage:ImageNamed(@"checkbox_selected") forState:UIControlStateSelected];
    self.selectBtn = selectBtn;
    [containView addSubview:selectBtn];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = kHexColor(@"#1C2B36");
    typeLabel.font = kFont(12);
    self.typeLabel = typeLabel;
    [containView addSubview:typeLabel];
    
    UILabel *saleLabel = [[UILabel alloc] init];
    saleLabel.textColor = kHexColor(@"#0E67F4");
    saleLabel.textAlignment = NSTextAlignmentRight;
    saleLabel.font = kFont(12);
    self.saleLabel = saleLabel;
    [containView addSubview:saleLabel];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [containView addSubview:dividerLine];
    
    @weakify(self);
    [[selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = !sender.selected;
        if (self.viewModel.selectOperation) self.viewModel.selectOperation(sender.selected);
    }];
    
    UIImageView *goodImageView = [[UIImageView alloc] init];
    self.goodImageView = goodImageView;
    [containView addSubview:goodImageView];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = kHexColor(@"#F85359");
    priceLabel.font = kFont(12);
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [containView addSubview:priceLabel];
    
    UILabel *tempLabel1 = [[UILabel alloc] init];
    tempLabel1.textColor = kHexColor(@"#1C2B36");
    tempLabel1.font = kFont(12);
    self.tempLabel1 = tempLabel1;
    [containView addSubview:tempLabel1];
    
    UILabel *tempLabel2 = [[UILabel alloc] init];
    tempLabel2.textColor = kHexColor(@"#1C2B36");
    tempLabel2.font = kFont(12);
    self.tempLabel2 = tempLabel2;
    [containView addSubview:tempLabel2];
    
    UILabel *tempLabel3 = [[UILabel alloc] init];
    tempLabel3.textColor = kHexColor(@"#1C2B36");
    tempLabel3.font = kFont(12);
    self.tempLabel3 = tempLabel3;
    [containView addSubview:tempLabel3];
    
    UILabel *tempLabel4 = [[UILabel alloc] init];
    tempLabel4.textColor = kHexColor(@"#1C2B36");
    tempLabel4.font = kFont(12);
    self.tempLabel4 = tempLabel4;
    [containView addSubview:tempLabel4];
    
    UILabel *tempLabel5 = [[UILabel alloc] init];
    tempLabel5.textColor = kHexColor(@"#1C2B36");
    tempLabel5.font = kFont(12);
    self.tempLabel5 = tempLabel5;
    [containView addSubview:tempLabel5];
    
    UILabel *tempLabel6 = [[UILabel alloc] init];
    tempLabel6.textColor = kHexColor(@"#1C2B36");
    tempLabel6.font = kFont(12);
    self.tempLabel6 = tempLabel6;
    [containView addSubview:tempLabel6];
    
    UILabel *tempLabel7 = [[UILabel alloc] init];
    tempLabel7.textColor = kHexColor(@"#1C2B36");
    tempLabel7.font = kFont(12);
    self.tempLabel7 = tempLabel7;
    [containView addSubview:tempLabel7];
    
    UILabel *tempLabel8 = [[UILabel alloc] init];
    tempLabel8.textColor = kHexColor(@"#1C2B36");
    tempLabel8.font = kFont(12);
    self.tempLabel8 = tempLabel8;
    [containView addSubview:tempLabel8];
    
    UILabel *tempLabel9 = [[UILabel alloc] init];
    tempLabel9.textColor = kHexColor(@"#1C2B36");
    tempLabel9.font = kFont(12);
    self.tempLabel9 = tempLabel9;
    [containView addSubview:tempLabel9];
}

- (void)_setupSubviewsConstraint {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, ZGCConvertToPx(10), 0));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containView).offset(ZGCConvertToPx(11));
        make.width.height.mas_equalTo(ZGCConvertToPx(22));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.containView);
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
    
    [self.saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right);
        make.top.mas_equalTo(self.containView);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(-10));
        make.size.mas_equalTo(self.typeLabel);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.typeLabel.mas_bottom);
    }];
    
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine.mas_bottom).offset(ZGCConvertToPx(10)-0.5);
        make.left.mas_equalTo(self.containView).offset(ZGCConvertToPx(10));
        make.width.height.mas_equalTo(ZGCConvertToPx(90));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.dividerLine.mas_bottom).offset(ZGCConvertToPx(10)-0.5);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.dividerLine.mas_bottom).offset(ZGCConvertToPx(10)-0.5);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel1.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel2.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel3.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel4.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel5.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel6.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel7.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
    
    [self.tempLabel9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodImageView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.tempLabel8.mas_bottom);
        make.right.mas_equalTo(self.containView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(21));
    }];
}

@end
