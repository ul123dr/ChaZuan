//
//  UpDownButton.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UpDownButton.h"

@interface UpDownButton ()

// 是否展示边界
@property (nonatomic, readwrite, assign) BOOL showBorder;
// 图片
@property (nonatomic, readwrite, strong) UIImageView *upImg;
// 文字
@property (nonatomic, readwrite, strong) UILabel *downL;

@end

@implementation UpDownButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
        [self _setupConstaints];
    }
    return self;
}

- (void)setShowBorder:(BOOL)showBorder {
    if (showBorder) {
        self.layer.borderColor = kHexColor(@"#f6f7f9").CGColor;
        self.layer.borderWidth = 0.35f;
    } else {
        self.layer.borderColor = UIColor.clearColor.CGColor;
        self.layer.borderWidth = 0.0f;
    }
}

- (void)setImage:(NSString *)imgPath title:(NSString *)title {
    if ([imgPath hasPrefix:@"http"]) [self.upImg sd_setImageWithURL:[NSURL URLWithString:imgPath]];
    else self.upImg.image = ImageNamed(imgPath);
    self.downL.text = title;
}

- (void)updateConstraint {
    [self.upImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
}

- (void)select:(id)sender {
    [super select:sender];
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    UIImageView *upImg = [[UIImageView alloc] init];
    self.upImg = upImg;
    [self addSubview:upImg];
    
    UILabel *downL = [[UILabel alloc] init];
    [downL setFont:kFont(12)];
    [downL setTextColor:kHexColor(@"#758099")];
    [downL setTextAlignment:NSTextAlignmentCenter];
    self.downL = downL;
    [self addSubview:downL];
}

- (void)_setupConstaints {
    [self.upImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(30));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(self.mas_width).multipliedBy(0.33);
    }];
    
    [self.downL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(self.upImg.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

@end
