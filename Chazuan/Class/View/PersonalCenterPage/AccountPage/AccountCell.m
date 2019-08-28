//
//  AccountCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountCell.h"

@interface AccountCell ()

// viewModel
@property (nonatomic, readwrite, strong) MemberItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIImageView *avatarIcon;
@property (nonatomic, readwrite, strong) UILabel *nameL;
@property (nonatomic, readwrite, strong) UILabel *roleL;
@property (nonatomic, readwrite, strong) UILabel *infoL;
@property (nonatomic, readwrite, strong) UIImageView *disclosureIndicatorIV;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation AccountCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"AccountCell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(MemberItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.nameL.text = viewModel.name;
    self.roleL.text = viewModel.role;
    self.infoL.text = viewModel.info;
    CGFloat width = sizeOfString(viewModel.name, kFont(15), kScreenW).width+5;
    [self.nameL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    [RACObserve(viewModel, avastar) subscribeNext:^(NSString *avastar) {
        if ([avastar hasPrefix:@"http"]) {
            [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:avastar] placeholderImage:ImageNamed(@"default")];
        } else {
            [self.avatarIcon setImage:ImageNamed(@"default")];
        }
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
}

- (void)_setupSubviews {
    UIImageView *avatarIcon = [[UIImageView alloc] initWithImage:ImageNamed(@"default")];
    avatarIcon.layer.borderWidth = 1;
    avatarIcon.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    avatarIcon.layer.cornerRadius = ZGCConvertToPx(24);
    avatarIcon.clipsToBounds = YES;
    self.avatarIcon = avatarIcon;
    [self.contentView addSubview:avatarIcon];
    
    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = kFont(15);
    nameL.textColor = kHexColor(@"#1C2B36");
    self.nameL = nameL;
    [self.contentView addSubview:nameL];
    
    UILabel *roleL = [[UILabel alloc] init];
    roleL.font = kFont(12);
    roleL.textColor = kHexColor(@"#1C2B36");
    self.roleL = roleL;
    [self.contentView addSubview:roleL];
    
    UILabel *infoL = [[UILabel alloc] init];
    infoL.font = kFont(13);
    infoL.textColor = kHexColor(@"#A7ABAD");
    self.infoL = infoL;
    [self.contentView addSubview:infoL];
    
    UIImageView *disclosureIndicatorIV = [[UIImageView alloc] initWithImage:ImageNamed(@"disclosureIndicator")];
    self.disclosureIndicatorIV = disclosureIndicatorIV;
    [self.contentView addSubview:disclosureIndicatorIV];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(16));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(12));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-16));
        make.width.mas_equalTo(self.avatarIcon.mas_height);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarIcon.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(18));
        make.height.mas_equalTo(ZGCConvertToPx(25));
        make.width.mas_equalTo(ZGCConvertToPx(80));
    }];
    
    [self.roleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(18));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-30));
        make.height.mas_equalTo(self.nameL);
    }];
    
    [self.infoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameL.mas_bottom);
        make.left.mas_equalTo(self.avatarIcon.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-30));
        make.height.mas_equalTo(self.nameL);
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
