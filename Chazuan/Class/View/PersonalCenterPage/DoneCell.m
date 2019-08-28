//
//  DoneCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DoneCell.h"

@interface DoneCell ()

// viewModel
@property (nonatomic, readwrite, strong) DoneItemViewModel *viewModel;
// 按钮
@property (nonatomic, readwrite, strong) ZGButton *doneBtn;

@end

@implementation DoneCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"DoneCell";
    DoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(DoneItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.doneBtn setTitle:viewModel.title forState:UIControlStateNormal];
    self.doneBtn.rac_command = viewModel.doneCommand;
    @weakify(self);
    [RACObserve(viewModel, hidden) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.doneBtn.hidden = x.boolValue;
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
    self.contentView.backgroundColor = COLOR_BG;
}

- (void)_setupSubviews {
    ZGButton *doneBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:COLOR_MAIN];
    [doneBtn.titleLabel setFont:kFont(16)];
    doneBtn.layer.cornerRadius = 4.0f;
    self.doneBtn = doneBtn;
    [self.contentView addSubview:doneBtn];
}

- (void)_setupSubviewsConstraint {
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(30), 0, ZGCConvertToPx(30)));
    }];
}

@end
