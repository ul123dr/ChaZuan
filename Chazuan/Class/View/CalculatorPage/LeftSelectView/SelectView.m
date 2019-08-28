//
//  SelectView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()

@property (nonatomic, readwrite, strong) NSArray *data;
@property (nonatomic, readwrite, assign) BOOL left;
@property (nonatomic, readwrite, copy) NSString *select;
// 当前选中button
@property (nonatomic, readwrite, strong) ZGButton *selectedBtn;

@end

@implementation SelectView

+ (instancetype)selectViewWithData:(NSArray *)data isLeft:(BOOL)left {
    return [[self alloc] initWithData:data isLeft:left];
}

- (instancetype)initWithData:(NSArray *)data isLeft:(BOOL)left {
    if (self = [super init]) {
        self.data = data;
        self.left = left;
        [self _setup];
        [self _setupSubviews];
    }
    return self;
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = COLOR_BG;
}

- (void)_setupSubviews {
    ZGButton *tempBtn;
    for (int i = 0; i < self.data.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        [btn.titleLabel setFont:kFont(15)];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN] forState:UIControlStateSelected];
        [btn setTitle:self.data[i] forState:UIControlStateNormal*UIControlStateSelected];
        if ((self.left && i == 0) || (!self.left && i==1)) {
            btn.selected = YES;
            self.selectedBtn = btn;
            self.select = self.data[i];
        }
        btn.tag = i;
        [self addSubview:btn];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (sender.tag == self.selectedBtn.tag) return;
            self.selectedBtn.selected = NO;
            sender.selected = YES;
            self.selectedBtn = sender;
            self.select = self.data[i];
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(self.left?0:0.35);
            if (tempBtn) {
                make.top.mas_equalTo(tempBtn.mas_bottom).offset(0.6);
                make.height.mas_equalTo(tempBtn);
            }
            else make.top.mas_equalTo(self);
            make.right.mas_equalTo(self.mas_right).offset(self.left?0.35:0);
            if (i == self.data.count-1) make.bottom.mas_equalTo(self.mas_bottom);
        }];
        tempBtn = btn;
    }
}

@end
