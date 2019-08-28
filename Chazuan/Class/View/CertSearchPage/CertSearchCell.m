//
//  CertSearchCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSearchCell.h"

@interface CertSearchCell ()

@property (nonatomic, readwrite, strong) CertSearchItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIImageView *iv;
@property (nonatomic, readwrite, strong) UILabel *certNameL;
@property (nonatomic, readwrite, strong) UIView *dividerLine1;
@property (nonatomic, readwrite, strong) UITextField *searchTF;
@property (nonatomic, readwrite, strong) ZGButton *searchBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine2;

@end

@implementation CertSearchCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"CertSearchCell";
    CertSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CertSearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    RAC(self.certNameL, text) = [RACObserve(viewModel, certTitle) takeUntil:self.rac_prepareForReuseSignal];
    self.searchTF.text = viewModel.searchText;
    RACChannelTo(viewModel, searchText) = self.searchTF.rac_newTextChannel;
    self.searchBtn.rac_command = viewModel.searchCommand;
}

#pragma mark - 辅助方法
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)_setupSubviews {
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = ImageNamed(@"certSearch_circle");
    self.iv = iv;
    [self.contentView addSubview:iv];
    
    UILabel *certNameL = [[UILabel alloc] init];
    certNameL.textColor = COLOR_MAIN;
    certNameL.font = kFont(15);
    certNameL.numberOfLines = 0;
    self.certNameL = certNameL;
    [self.contentView addSubview:certNameL];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = COLOR_BG;
    self.dividerLine1 = dividerLine1;
    [self.contentView addSubview:dividerLine1];
    
    UITextField *searchTF = [[UITextField alloc] init];
    searchTF.backgroundColor = UIColor.whiteColor;
    searchTF.textColor = kHexColor(@"#1C2B36");
    searchTF.font = kFont(15);
    searchTF.placeholder = @"请输入证书编号";
    self.searchTF = searchTF;
    [self.contentView addSubview:searchTF];
    
    UIView *dividerLine2 = [[UIView alloc] init];
    dividerLine2.backgroundColor = COLOR_BG;
    self.dividerLine2 = dividerLine2;
    [self.contentView addSubview:dividerLine2];
    
    ZGButton *searchBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:kFont(15)];
    searchBtn.layer.cornerRadius = 2;
    self.searchBtn = searchBtn;
    [self.contentView addSubview:searchBtn];
}

- (void)_setupSubviewsConstraint {
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(20));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(22));
        make.width.height.mas_equalTo(ZGCConvertToPx(6));
    }];
    
    [self.certNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iv.mas_right).offset(ZGCConvertToPx(8));
        make.top.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-20));
        make.height.mas_equalTo(ZGCConvertToPx(49));
    }];
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(ZGCConvertToPx(1));
        make.top.mas_equalTo(self.certNameL.mas_bottom);
    }];
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-20));
        make.top.mas_equalTo(self.dividerLine1.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(49));
    }];
    
    [self.dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(ZGCConvertToPx(1));
        make.top.mas_equalTo(self.searchTF.mas_bottom);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine2.mas_bottom).offset(ZGCConvertToPx(40));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(40));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-20));
    }];
}

@end
