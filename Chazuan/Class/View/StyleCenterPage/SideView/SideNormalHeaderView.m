//
//  SideNormalHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SideNormalHeaderView.h"

@interface SideNormalHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;

@end

@implementation SideNormalHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubview];
        [self _setupConstraint];
        [self bind];
    }
    return self;
}

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, header);
}

- (void)_setupSubview {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#1C2B36");
    titleLabel.font = kBoldFont(15);
    self.titleLabel = titleLabel;
    [self addSubview:self.titleLabel];
}

- (void)_setupConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(10), 0, ZGCConvertToPx(10)));
    }];
}

@end
