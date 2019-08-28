//
//  SettingCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()

// viewModel
@property (nonatomic, readwrite, strong) SettingItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UITextField *textField;
@property (nonatomic, readwrite, strong) UILabel *descTitleL;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation SettingCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(SettingItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleL.text = viewModel.title;
    self.textField.text = viewModel.value;
    if (viewModel.type == 0) {
        self.textField.placeholder = @"请输入汇率";
        self.descTitleL.text = @"";
    } else {
        self.textField.placeholder = @"请输入失效时间";
        self.descTitleL.text = @"分钟";
    }
    [self.descTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kStringIsEmpty(self.descTitleL.text)?0:ZGCConvertToPx(40));
    }];
    
    RACChannelTo(viewModel, value) = self.textField.rac_newTextChannel;
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
    titleL.textColor = kHexColor(@"#98A2A9");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = kHexColor(@"#1C2B36");
    textField.font = kFont(15);
    self.textField = textField;
    [self.contentView addSubview:textField];
    
    UILabel *descTitleL = [[UILabel alloc] init];
    descTitleL.font = kFont(15);
    descTitleL.textColor = kHexColor(@"#98A2A9");
    self.descTitleL = descTitleL;
    [self.contentView addSubview:descTitleL];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ZGCConvertToPx(140));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.descTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).offset(ZGCConvertToPx(10));
        make.top.bottom.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(0);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
