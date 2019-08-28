//
//  KeyboardView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "KeyboardView.h"

@interface KeyboardView ()

@property (nonatomic, readwrite, strong) NSArray *data;
@property (nonatomic, readwrite, strong) NSMutableArray *btnArr;

@end

@implementation KeyboardView

+ (instancetype)keyboardView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsContraints];
    }
    return self;
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = COLOR_BG;
    self.data = @[@"1",@"2",@"3",@"d",@"4",@"5",@"6",@"0",@"7",@"8",@"9",@"."];
    self.btnArr = [NSMutableArray array];
}

- (void)_setupSubviews {
    for (int i = 0; i < self.data.count; i++) {
        NSString *title = self.data[i];
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        [btn.titleLabel setFont:kBoldFont(24)];
        [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        if ([title isEqualToString:@"d"]) {
            [btn setImage:ImageNamed(@"calculator_11") forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(21), ZGCConvertToPx(15), ZGCConvertToPx(21), ZGCConvertToPx(15));
        } else if ([title isEqualToString:@"."]) {
            [btn setImage:ImageNamed(@"calculator_15") forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(ZGCConvertToPx(25.5), ZGCConvertToPx(24.5), ZGCConvertToPx(25.5), ZGCConvertToPx(24.5));
        } else {
            [btn setTitle:title forState:UIControlStateNormal];
        }
        [self addSubview:btn];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (self.handle) self.handle(title);
        }];
        [self.btnArr addObject:btn];
    }
}

- (void)_setupSubviewsContraints {
    CGFloat width = ZGCConvertToPx(56);
    CGFloat height = ZGCConvertToPx(58);
    for (int i = 0; i < self.data.count; i++) {
        ZGButton *btn = self.btnArr[i];
        NSInteger row = i/4;
        NSInteger column = i%4;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(column*(width+0.5));
            make.top.mas_equalTo(self).offset(row*(height+0.5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    }
}

@end
