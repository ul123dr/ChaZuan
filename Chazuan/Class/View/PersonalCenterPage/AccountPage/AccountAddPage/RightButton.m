//
//  RightButton.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "RightButton.h"

@implementation RightButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageIcon.image = selected?ImageNamed(@"vipAdd_selected"):ImageNamed(@"vipAdd_circle");
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    UIImageView *imageIcon = [[UIImageView alloc] init];
    imageIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.imageIcon = imageIcon;
    [self addSubview:imageIcon];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
}

- (void)_setupSubviewsConstraint {
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(ZGCConvertToPx(21));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(31), 0, 0));
    }];
}

@end
