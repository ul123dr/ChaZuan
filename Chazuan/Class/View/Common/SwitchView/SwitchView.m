//
//  SwitchView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SwitchView.h"

@interface SwitchView ()

@property (nonatomic, readwrite, assign) NSInteger switchType;
@property (nonatomic, readwrite, strong) ZGButton *leftBtn;
@property (nonatomic, readwrite, strong) ZGButton *rightBtn;

@end

@implementation SwitchView

+ (instancetype)switchView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self _setup];
        // 创建控件
        [self _setupSubviews];
        // 控件布局
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = UIColor.clearColor;
    self.switchType = 1;
}

- (void)_setupSubviews {
    ZGButton *leftBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    leftBtn.selected = YES;
    [leftBtn.titleLabel setFont:kFont(18)];
    [leftBtn setTitleColor:kHexColor(@"#C1D5F8") forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    self.leftBtn = leftBtn;
    [self addSubview:leftBtn];
    
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn.titleLabel setFont:kFont(18)];
    [rightBtn setTitleColor:kHexColor(@"#C1D5F8") forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    self.rightBtn = rightBtn;
    [self addSubview:rightBtn];
    
    @weakify(self);
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = YES;
        self.rightBtn.selected = NO;
        self.switchType = 1;
    }];
    
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        sender.selected = YES;
        self.leftBtn.selected = NO;
        self.switchType = 2;
    }];
}

- (void)_setupSubviewsConstraint {
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.left.mas_equalTo(self.leftBtn.mas_right).offset(ZGCConvertToPx(20));
        make.width.mas_equalTo(self.leftBtn);
    }];
}

@end
