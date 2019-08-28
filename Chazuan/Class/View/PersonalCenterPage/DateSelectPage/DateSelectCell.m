//
//  DateSelectCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DateSelectCell.h"

@interface DateSelectCell ()

// viewModel
@property (nonatomic, readwrite, strong) DateSelectItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) ZGButton *dateSelectBtn;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation DateSelectCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DateSelectCell";
    DateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(DateSelectItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    self.titleL.text = viewModel.title;
    [[RACObserve(viewModel, date) deliverOnMainThread] subscribeNext:^(NSString *x) {
        @strongify(self);
        if (kStringIsEmpty(x)) {
            [self.dateSelectBtn setTitle:@"年/月/日" forState:UIControlStateNormal];
        } else {
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [formatter dateFromString:x];
            [formatter setDateFormat:@"yyyy年/MM月/dd日"];
            [self.dateSelectBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
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
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kFont(15);
    titleL.textColor = kHexColor(@"#98A2A9");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    ZGButton *dateSelectBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [dateSelectBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [dateSelectBtn.titleLabel setFont:kFont(15)];
    dateSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.dateSelectBtn = dateSelectBtn;
    [self.contentView addSubview:dateSelectBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[[dateSelectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [self.viewModel.dateSub sendNext:@(self.viewModel.start)];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
    }];
    
    [self.dateSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.titleL.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.width.mas_equalTo(self.titleL);
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
