//
//  BannerCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BannerCell.h"
#import "CycleView.h"

@interface BannerCell ()

@property (nonatomic, readwrite, strong) BannerItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) CycleView *cycleView;

@end

@implementation BannerCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"BannerCell";
    BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(BannerItemViewModel *)viewModel {
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
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)_setupSubviews {
    CycleView *cycleView = [CycleView cycleView];
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
