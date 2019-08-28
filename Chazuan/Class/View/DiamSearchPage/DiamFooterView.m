//
//  DiamFooterView.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamFooterView.h"

@interface DiamFooterView ()

@property (nonatomic, readwrite, strong) DiamGroupViewModel *viewModel;

@property (nonatomic, readwrite, strong) ZGButton *moreBtn;

@end


@implementation DiamFooterView

+ (instancetype)footerWithTableView:(UITableView *)tableView {
    static NSString * ID = @"DiamFooterView";
    DiamFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (kObjectIsNil(footer)) {
        // 缓冲池没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(DiamGroupViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [RACObserve(viewModel, showBtn) subscribeNext:^(NSNumber *showBtn) {
        @strongify(self);
        self.moreBtn.hidden = !showBtn.boolValue;
    }];
}

#pragma mark - 辅助方法
- (void)_setupSubviews {
   
    ZGButton *moreBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setBackgroundColor:kHexColor(@"#3882FF")];
    [moreBtn setTitle:@"高级搜索" forState:UIControlStateNormal];
    [moreBtn.titleLabel setFont:kFont(13)];
    moreBtn.layer.cornerRadius = 2;
    self.moreBtn = moreBtn;
    [self.contentView addSubview:moreBtn];
    
    @weakify(self);
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.operation) self.viewModel.operation();
    }];
}

- (void)_setupSubviewsConstraint {
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(8), ZGCConvertToPx(140), ZGCConvertToPx(8), ZGCConvertToPx(140)));
    }];
}

@end
