//
//  NoteCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NoteCell.h"

@interface NoteCell ()

// viewModel
@property (nonatomic, readwrite, strong) NoteItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UILabel *valueL;
@property (nonatomic, readwrite, strong) UILabel *dateL;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation NoteCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"NoteCell";
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(NoteItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleL.text = [SingleInstance stringForKey:ZGCUserWwwKey];
    self.valueL.text = viewModel.remark;
    self.dateL.text = viewModel.date;
    
    CGFloat height = sizeOfString(viewModel.remark, kFont(13), kScreenW-ZGCConvertToPx(30)).height+5;
    [self.valueL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
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
    titleL.font = kFont(13);
    titleL.textColor = kHexColor(@"#1C2B36");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UILabel *dateL = [[UILabel alloc] init];
    dateL.textAlignment = NSTextAlignmentRight;
    dateL.font = kFont(13);
    dateL.textColor = kHexColor(@"#98A2A9");
    self.dateL = dateL;
    [self.contentView addSubview:dateL];
    
    UILabel *valueL = [[UILabel alloc] init];
    valueL.numberOfLines = 0;
    valueL.font = kFont(13);
    valueL.textColor = kHexColor(@"#1C2B36");
    self.valueL = valueL;
    [self.contentView addSubview:valueL];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(15));
    }];
    
    [self.dateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right);
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(self.titleL);
        make.width.mas_equalTo(self.titleL).multipliedBy(0.8);
    }];
    
    [self.valueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(ZGCConvertToPx(7));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.height.mas_equalTo(ZGCConvertToPx(15));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
