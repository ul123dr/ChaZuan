//
//  StyleInfoCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleInfoCell.h"

@interface StyleInfoCell ()

@property (nonatomic, readwrite, strong) StyleInfoItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *nameLabel;
@property (nonatomic, readwrite, strong) UILabel *designNoLabel;
@property (nonatomic, readwrite, strong) UILabel *designNoValueLabel;
@property (nonatomic, readwrite, strong) UILabel *materialLabel;
@property (nonatomic, readwrite, strong) UILabel *materialValueLabel;
@property (nonatomic, readwrite, strong) UILabel *sizeLabel;
@property (nonatomic, readwrite, strong) UILabel *sizeValueLabel;
@property (nonatomic, readwrite, strong) UILabel *sideLabel;
@property (nonatomic, readwrite, strong) UILabel *sideValueLabel;
@property (nonatomic, readwrite, strong) UILabel *seriesLabel;
@property (nonatomic, readwrite, strong) UILabel *seriesValueLabel;
@property (nonatomic, readwrite, strong) UILabel *remarkLabel;
@property (nonatomic, readwrite, strong) UILabel *remarkValueLabel;
@property (nonatomic, readwrite, strong) UILabel *countLabel;

@end

@implementation StyleInfoCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"StyleInfoCell";
    StyleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(StyleInfoItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(viewModel, name) subscribeNext:^(NSString *name) {
        @strongify(self);
        if (kStringIsEmpty(name))
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        else
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ZGCConvertToPx(25));
            }];
        self.nameLabel.text = name;
    }];
    [RACObserve(viewModel, designNo) subscribeNext:^(NSString *designNo) {
        @strongify(self);
        self.designNoLabel.text = @"款号";
        self.designNoValueLabel.text = designNo;
    }];
    [[RACObserve(viewModel, material) ignore:nil] subscribeNext:^(NSString *material) {
        @strongify(self);
        self.materialLabel.text = @"金重";
        self.materialValueLabel.text = material;
    }];
    [[RACObserve(viewModel, size) ignore:nil] subscribeNext:^(NSString *size) {
        @strongify(self);
        self.sizeLabel.text = @"主石";
        self.sizeValueLabel.text = size;
    }];
    [[RACObserve(viewModel, designSeries) ignore:nil] subscribeNext:^(NSString *series) {
        @strongify(self);
        self.seriesLabel.text = @"系列款";
        self.seriesValueLabel.text = series;
        CGFloat seriesHeight = sizeOfString(series, kFont(13), kScreenW-ZGCConvertToPx(80)).height+5;
        if (seriesHeight < ZGCConvertToPx(25)) seriesHeight = ZGCConvertToPx(25);
        [self.seriesValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(seriesHeight);
        }];
    }];
//    @property (nonatomic, readwrite, strong) UILabel *sideLabel;
//    @property (nonatomic, readwrite, strong) UILabel *sideValueLabel;
    [[RACObserve(viewModel, remark) ignore:nil] subscribeNext:^(NSString *remark) {
        @strongify(self);
        self.remarkLabel.text = @"款式描述";
        self.remarkValueLabel.text = remark;
    }];
    [[RACObserve(viewModel, record) ignore:nil] subscribeNext:^(NSMutableAttributedString *record) {
        @strongify(self);
        self.countLabel.attributedText = record;
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
- (void)_setupSubviews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kHexColor(@"#020D2C");
    nameLabel.font = kFont(13);
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *designNoLabel = [[UILabel alloc] init];
    designNoLabel.textColor = kHexColor(@"#020D2C");
    designNoLabel.font = kFont(13);
    self.designNoLabel = designNoLabel;
    [self.contentView addSubview:designNoLabel];
    
    UILabel *designNoValueLabel = [[UILabel alloc] init];
    designNoValueLabel.textColor = kHexColor(@"#3882FF");
    designNoValueLabel.font = kFont(13);
    self.designNoValueLabel = designNoValueLabel;
    [self.contentView addSubview:designNoValueLabel];
    
    UILabel *materialLabel = [[UILabel alloc] init];
    materialLabel.textColor = kHexColor(@"#020D2C");
    materialLabel.font = kFont(13);
    self.materialLabel = materialLabel;
    [self.contentView addSubview:materialLabel];
    
    UILabel *materialValueLabel = [[UILabel alloc] init];
    materialValueLabel.textColor = kHexColor(@"#3882FF");
    materialValueLabel.font = kFont(13);
    self.materialValueLabel = materialValueLabel;
    [self.contentView addSubview:materialValueLabel];
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textColor = kHexColor(@"#020D2C");
    sizeLabel.font = kFont(13);
    self.sizeLabel = sizeLabel;
    [self.contentView addSubview:sizeLabel];

    UILabel *sizeValueLabel = [[UILabel alloc] init];
    sizeValueLabel.textColor = kHexColor(@"#3882FF");
    sizeValueLabel.font = kFont(13);
    self.sizeValueLabel = sizeValueLabel;
    [self.contentView addSubview:sizeValueLabel];

//    UILabel *sideLabel = [[UILabel alloc] init];
//    sideLabel.textColor = kHexColor(@"#020D2C");
//    sideLabel.font = kFont(13);
//    self.sideLabel = sideLabel;
//    [self.contentView addSubview:sideLabel];
//
//    UILabel *sideValueLabel = [[UILabel alloc] init];
//    sideValueLabel.textColor = kHexColor(@"#3882FF");
//    sideValueLabel.font = kFont(13);
//    self.sideValueLabel = sideValueLabel;
//    [self.contentView addSubview:sideValueLabel];

    UILabel *seriesLabel = [[UILabel alloc] init];
    seriesLabel.textColor = kHexColor(@"#020D2C");
    seriesLabel.font = kFont(13);
    self.seriesLabel = seriesLabel;
    [self.contentView addSubview:seriesLabel];

    UILabel *seriesValueLabel = [[UILabel alloc] init];
    seriesValueLabel.textColor = kHexColor(@"#3882FF");
    seriesValueLabel.font = kFont(13);
    seriesValueLabel.numberOfLines = 0;
    self.seriesValueLabel = seriesValueLabel;
    [self.contentView addSubview:seriesValueLabel];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.textColor = kHexColor(@"#020D2C");
    remarkLabel.font = kFont(13);
    self.remarkLabel = remarkLabel;
    [self.contentView addSubview:remarkLabel];
    
    UILabel *remarkValueLabel = [[UILabel alloc] init];
    remarkValueLabel.textColor = kHexColor(@"#3882FF");
    remarkValueLabel.font = kFont(13);
    self.remarkValueLabel = remarkValueLabel;
    [self.contentView addSubview:remarkValueLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.font = kFont(14);
    countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel = countLabel;
    [self.contentView addSubview:countLabel];
}

- (void)_setupSubviewsConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(4));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
    }];
    [self.designNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    [self.designNoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.designNoLabel);
        make.left.mas_equalTo(self.designNoLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.designNoLabel);
    }];
    [self.materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.designNoLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    [self.materialValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.materialLabel);
        make.left.mas_equalTo(self.materialLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.materialLabel);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.materialLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    [self.sizeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel);
        make.left.mas_equalTo(self.sizeLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.sizeLabel);
    }];
//    [self.sideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.sizeLabel.mas_bottom);
//        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
//        make.height.mas_equalTo(ZGCConvertToPx(25));
//        make.width.mas_equalTo(ZGCConvertToPx(60));
//    }];
//    [self.sideValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.sideLabel);
//        make.left.mas_equalTo(self.sideLabel.mas_right);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
//        make.height.mas_equalTo(self.sideLabel);
//    }];
    [self.seriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sizeLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    [self.seriesValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seriesLabel);
        make.left.mas_equalTo(self.seriesLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seriesValueLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(60));
    }];
    [self.remarkValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkLabel);
        make.left.mas_equalTo(self.remarkLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.remarkLabel);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.designNoLabel);
        make.left.mas_equalTo(self.designNoLabel.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(self.designNoLabel);
    }];
}

@end
