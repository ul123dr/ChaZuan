//
//  AvatarCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AvatarCell.h"

@interface AvatarCell ()

// viewModel
@property (nonatomic, readwrite, strong) AvatarItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UIImageView *avatarIcon;
@property (nonatomic, readwrite, strong) ZGButton *clickBtn;
@property (nonatomic, readwrite, strong) UIImageView *disclosureIndicatorIV;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation AvatarCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"AvatarCell";
    AvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(AvatarItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleL.text = viewModel.title;
    self.disclosureIndicatorIV.hidden = !viewModel.shouldHideDisclosureIndicator;
    self.clickBtn.hidden = viewModel.shouldHideDisclosureIndicator;
    [RACObserve(viewModel, avatar) subscribeNext:^(NSString *avatar) {
        if ([avatar hasPrefix:@"http"])
            [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:avatar]];
        else
            [self.avatarIcon setImage:ImageNamed(avatar)];
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
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kFont(15);
    titleL.textColor = kHexColor(@"#1A2B36");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UIImageView *avatarIcon = [[UIImageView alloc] init];
    avatarIcon.layer.cornerRadius = ZGCConvertToPx(35);
    avatarIcon.clipsToBounds = YES;
    self.avatarIcon = avatarIcon;
    [self.contentView addSubview:avatarIcon];
    
    UIImageView *disclosureIndicatorIV = [[UIImageView alloc] initWithImage:ImageNamed(@"disclosureIndicator")];
    self.disclosureIndicatorIV = disclosureIndicatorIV;
    [self.contentView addSubview:disclosureIndicatorIV];
    
    ZGButton *clickBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = UIColor.clearColor;
    self.clickBtn = clickBtn;
    [self.contentView addSubview:clickBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.operation) self.viewModel.operation();
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
    }];
    
    [self.avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(9));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-9));
        make.left.mas_equalTo(self.titleL.mas_right);
        make.width.mas_equalTo(self.avatarIcon.mas_height);
    }];
    
    [self.disclosureIndicatorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarIcon.mas_right).offset(ZGCConvertToPx(5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.width.height.mas_equalTo(ZGCConvertToPx(16));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
