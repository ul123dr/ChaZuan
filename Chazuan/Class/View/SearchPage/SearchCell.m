//
//  SearchCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

// viewModel
@property (nonatomic, readwrite, strong) SearchItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *logLabel;
@property (nonatomic, readwrite, strong) ZGButton *deleteBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation SearchCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(SearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    RAC(self.logLabel, text) = [RACObserve(viewModel, historyStr) takeUntil:self.rac_prepareForReuseSignal];
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
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)_setupSubviews {
    UILabel *logLabel = [[UILabel alloc] init];
    logLabel.textColor = kHexColor(@"#7B7B7B");
    logLabel.font = kFont(13);
    self.logLabel = logLabel;
    [self.contentView addSubview:logLabel];
    
    ZGButton *deleteBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:ImageNamed(@"icon_clear") forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self.contentView addSubview:deleteBtn];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_BG;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
    
    @weakify(self);
    [[[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(ZGButton *x) {
        @strongify(self);
        if (self.viewModel.operation) self.viewModel.operation();
    }];
}

- (void)_setupSubviewsConstraint {
    [self.logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(10), 0, ZGCConvertToPx(44)));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, kScreenW-ZGCConvertToPx(44), 0, 0));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.mas_equalTo(self.contentView);
    }];
}

@end
