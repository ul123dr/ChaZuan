//
//  SideCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SideCell.h"

@interface SideCell ()

@property (nonatomic, readwrite, strong) UILabel *nameLabel;

@end

@implementation SideCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
        [self _setupConstraint];
        [self bind];
    }
    return self;
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, name) subscribeNext:^(NSString *name) {
        @strongify(self);
        self.nameLabel.text = name;
    }];
    [RACObserve(self, sideSelected) subscribeNext:^(NSNumber *selected) {
        @strongify(self);
        self.nameLabel.textColor = selected.boolValue?UIColor.whiteColor:UIColor.blackColor;
        self.nameLabel.backgroundColor = selected.boolValue?kHexColor(@"#3882FF"):kHexColor(@"#EDF1F2");
    }];
}

- (void)_setupSubviews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = UIColor.blackColor;
    nameLabel.backgroundColor = kHexColor(@"#EDF1F2");
    nameLabel.font = kFont(12);
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
}

- (void)_setupConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
