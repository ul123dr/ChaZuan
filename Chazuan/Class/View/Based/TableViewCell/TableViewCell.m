//
//  TableViewCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

/// viewModel
@property (nonatomic, readwrite, strong) CommonItemViewModel *viewModel;
// 红点
@property (nonatomic, readwrite, strong) UILabel *redDotL;
// access 箭头
@property (nonatomic, readwrite, strong) UIImageView *disclosureIndicatorIV;
// 分隔线
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;
// cellType
@property (nonatomic, readwrite, assign) UITableViewCellStyle cellStyle;

@end

@implementation TableViewCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CommonItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    if (kStringIsNotEmpty(viewModel.icon)) {
        if ([viewModel.icon hasPrefix:@"http"])
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.icon] placeholderImage:ImageNamed(@"hold_icon")];
        else
            [self.imageView setImage:ImageNamed(viewModel.icon)];
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(49));
        }];
    } else {
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        }];
    }
    [self.textLabel setText:viewModel.title];
    if (viewModel.titleColor) self.textLabel.backgroundColor = viewModel.titleColor;
    if (viewModel.subColor) self.detailTextLabel.backgroundColor = viewModel.subColor;
    self.disclosureIndicatorIV.hidden = viewModel.shouldHideDisclosureIndicator;
    self.dividerLine.hidden = viewModel.shouldHideDividerLine;
    
    if (viewModel.cellStyle == UITableViewCellStyleValue1) {
        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(viewModel.shouldHideDisclosureIndicator?ZGCConvertToPx(-15):ZGCConvertToPx(-30));
        }];
    }
    
    @weakify(self);
    [RACObserve(viewModel, shouldHideRedDot) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.redDotL.hidden = x.boolValue;
    }];
    [[RACObserve(viewModel, subTitle) ignore:nil] subscribeNext:^(NSString *title) {
        @strongify(self);
        self.detailTextLabel.text = title;
        CGFloat maxWidth = kScreenW-ZGCConvertToPx(20);
        if (kStringIsNotEmpty(viewModel.icon)) maxWidth-=ZGCConvertToPx(49);
        if (!self.disclosureIndicatorIV.hidden) maxWidth-=ZGCConvertToPx(41);
        CGFloat width = sizeOfString(title, kFont(12), maxWidth).width;
        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width+5);
        }];
    }];
}

#pragma mark - Privite Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellStyle = style;
        // 设置
        [self _setup];
        // 创建子控件
        [self _setupSubviews];
        // 布局
        [self _setupSubviewsConstraint];
    }
    return self;
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
}

- (void)_setupSubviews {
    UILabel *redDotL = [[UILabel alloc] init];
    redDotL.backgroundColor = kHexColor(@"#F12F09");
    redDotL.layer.cornerRadius = ZGCConvertToPx(4);
    redDotL.clipsToBounds = YES;
    self.redDotL = redDotL;
    [self.contentView addSubview:redDotL];
    
    self.textLabel.font = kFont(15);
    self.textLabel.textColor = kHexColor(@"#222222");
    
    self.detailTextLabel.font = kFont(12);
    self.detailTextLabel.textColor = kHexColor(@"#999999");
    self.detailTextLabel.numberOfLines = 2;
    self.detailTextLabel.backgroundColor = UIColor.greenColor;
    
    UIImageView *disclosureIndicatorIV = [[UIImageView alloc] initWithImage:ImageNamed(@"disclosureIndicator")];
    self.disclosureIndicatorIV = disclosureIndicatorIV;
    [self.contentView addSubview:disclosureIndicatorIV];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.width.height.mas_equalTo(ZGCConvertToPx(24));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.redDotL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(ZGCConvertToPx(-4));
        make.top.mas_equalTo(self.imageView).offset(ZGCConvertToPx(-4));
        make.width.height.mas_equalTo(ZGCConvertToPx(8));
    }];
    
    if (self.cellStyle == UITableViewCellStyleDefault || self.cellStyle == UITableViewCellStyleValue1) {
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
        }];
    } else if (self.cellStyle == UITableViewCellStyleSubtitle) {
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_centerY);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.textLabel);
        }];
    }
    
    [self.disclosureIndicatorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.width.height.mas_equalTo(ZGCConvertToPx(16));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
