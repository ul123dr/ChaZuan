//
//  CyclePicCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CyclePicCell.h"
#import "StyleCycleView.h"

@interface CyclePicCell ()

@property (nonatomic, readwrite, strong) StylePicItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) StyleCycleView *cycleView;

@end

@implementation CyclePicCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"CyclePicCell";
    CyclePicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(StylePicItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.cycleView setModels:viewModel.model];
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
- (void)_setupSubviews {
    StyleCycleView *cycleView = [StyleCycleView cycleView];
    self.cycleView = cycleView;
    [self.contentView addSubview:cycleView];
    
    @weakify(self);
    cycleView.actionBlock = ^(NSInteger index) {
        @strongify(self);
        if (index < self.viewModel.model.count)
            [self.viewModel.bannerClickSub sendNext:self.viewModel.model[index]];
    };
}

- (void)_setupSubviewsConstraint {
    [self.cycleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
