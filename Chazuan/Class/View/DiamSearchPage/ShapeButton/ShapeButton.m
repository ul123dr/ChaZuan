//
//  ShapeButton.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShapeButton.h"

@implementation ShapeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.borderColor = COLOR_LINE.CGColor;
    self.layer.borderWidth = 1;
}

- (void)_setupSubviews {
    UIImageView *imageIcon = [[UIImageView alloc] init];
    imageIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.imageIcon = imageIcon;
    [self addSubview:imageIcon];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = kFont(12);
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
}

- (void)_setupSubviewsConstraint {
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(ZGCConvertToPx(40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageIcon.mas_bottom);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(18));
    }];
}

@end
