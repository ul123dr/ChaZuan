//
//  CycleViewCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CycleViewCell.h"

@interface CycleViewCell ()

@property (nonatomic, strong) UIImageView *cycleImg;
@property (nonatomic, strong) UILabel *cycleL;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel *nameL;

@end

@implementation CycleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.cycleImg];
        [self.contentView addSubview:self.cycleL];
        [self.contentView addSubview:self.coverView];
        [self.coverView addSubview:self.nameL];
        
        [self addConstraint];
    }
    return self;
}

#pragma mark - Setter
- (void)bindModel:(CycleCollectionModel *)model {
    self.cycleL.hidden = YES;
    if ([model.imgUrl hasPrefix:@"http"])
        [self.cycleImg sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    else
        [self.cycleImg setImage:ImageNamed(model.imgUrl)];
    self.coverView.hidden = kStringIsEmpty(model.title);
    self.nameL.text = model.title;
}

#pragma mark - Constraint
- (void)addConstraint {
    [self.cycleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.cycleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView.mas_left).offset(ZGCConvertToPx(15));
        make.top.mas_equalTo(self.coverView.mas_top);
        make.bottom.mas_equalTo(self.coverView.mas_bottom);
        make.right.mas_equalTo(self.coverView.mas_right).offset(ZGCConvertToPx(-50));
    }];
}

#pragma mark - Getter
- (UIImageView *)cycleImg {
    if (!_cycleImg) {
        _cycleImg = [[UIImageView alloc] init];
        _cycleImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleImg;
}

- (UILabel *)cycleL {
    if (!_cycleL) {
        _cycleL = [[UILabel alloc] init];
        _cycleL.font = kFont(12);
        _cycleL.textColor = kHexColor(@"#F12F09");
    }
    return _cycleL;
}

- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.backgroundColor = kHexColorAlpha(@"#999999", 0.5);
    }
    return _coverView;
}

- (UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.font = kFont(12);
        _nameL.textColor = UIColor.whiteColor;
    }
    return _nameL;
}

@end
