//
//  PersonalHeaderCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PersonalHeaderCell.h"

@interface PersonalHeaderCell ()

@property (nonatomic, readwrite, strong) PersonalItemViewModel *viewModel;
// access 箭头
@property (nonatomic, readwrite, strong) UIImageView *disclosureIndicatorIV;
// 分隔线
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation PersonalHeaderCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"PersonalHeaderCell";
    PersonalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(PersonalItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    if ([viewModel.icon hasPrefix:@"http"])
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.icon] placeholderImage:ImageNamed(@"personal_msg_03")];
    else
        [self.imageView setImage:ImageNamed(viewModel.icon)];
    self.textLabel.text = viewModel.title;
    self.detailTextLabel.text = viewModel.subTitle;
    self.disclosureIndicatorIV.hidden = viewModel.shouldHideDisclosureIndicator;
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
    self.imageView.layer.cornerRadius = ZGCConvertToPx(35);
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.font = kFont(15);
    self.textLabel.textColor = kHexColor(@"#1C2B36");
    
    self.detailTextLabel.font = kFont(12);
    self.detailTextLabel.textColor = kHexColor(@"#999999");
    
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
        make.width.height.mas_equalTo(ZGCConvertToPx(70));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(30));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.bottom.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.imageView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(30));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
    }];
    
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
