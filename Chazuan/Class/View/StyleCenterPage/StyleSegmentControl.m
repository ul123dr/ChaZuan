//
//  StyleSegmentControl.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleSegmentControl.h"

@interface StyleSegmentControl ()

@property (nonatomic, readwrite, assign) StyleType type;

@property (nonatomic, readwrite, strong) ZGButton *timeBtn;
@property (nonatomic, readwrite, strong) ZGButton *priceBtn;
@property (nonatomic, readwrite, strong) ZGButton *filterBtn;
@property (nonatomic, readwrite, strong) NSMutableArray *btnArray;

@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation StyleSegmentControl

+ (instancetype)segmentControl:(StyleType)type {
    return [[self alloc] initWithStyleType:type];
}

- (instancetype)initWithStyleType:(StyleType)type {
    if (self = [super init]) {
        self.type = type;
        
        [self _setup];
        [self _setupSubviews];
        [self _setupConstraint];
    }
    return self;
}

- (void)_setup {
    self.btnArray = [NSMutableArray array];
    self.styleSub = [RACSubject subject];
}

- (void)resetSegment {
    self.selectBtn.selected = NO;
    self.timeBtn.selected = YES;
    self.selectBtn = self.timeBtn;
}

- (void)_setupSubviews {
    ZGButton *timeBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    [timeBtn.titleLabel setFont:kFont(15)];
    [timeBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [timeBtn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    timeBtn.tag = 0;
    timeBtn.selected = YES;
    self.timeBtn = timeBtn;
    [self addSubview:timeBtn];
    self.selectBtn = timeBtn;
    [self.btnArray addObject:timeBtn];
   
    if (self.type == StyleCenter) { // 时间、专区、价格、筛选
        ZGButton *categoryBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [categoryBtn setTitle:@"专区" forState:UIControlStateNormal];
        [categoryBtn.titleLabel setFont:kFont(15)];
        [categoryBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
        [categoryBtn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        categoryBtn.tag = 1;
        self.categoryBtn = categoryBtn;
        [self addSubview:categoryBtn];
        [self.btnArray addObject:categoryBtn];
    }
    ZGButton *priceBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [priceBtn.titleLabel setFont:kFont(15)];
    [priceBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [priceBtn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    priceBtn.tag = 4;
    self.priceBtn = priceBtn;
    [self addSubview:priceBtn];
    [self.btnArray addObject:priceBtn];
    
    ZGButton *filterBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
//    filterBtn.imageAlignment = ButtonImageAlignmentRight;
    [filterBtn setTitle:@"筛选 " forState:UIControlStateNormal];
    [filterBtn setImage:ImageNamed(@"style_sel") forState:UIControlStateNormal];
    [filterBtn.titleLabel setFont:kFont(15)];
    [filterBtn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
    [filterBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -ZGCConvertToPx(28), 0, ZGCConvertToPx(28))];
    [filterBtn setImageEdgeInsets:UIEdgeInsetsMake(ZGCConvertToPx(16), ZGCConvertToPx(30), ZGCConvertToPx(16), -ZGCConvertToPx(30))];
    filterBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    filterBtn.tag = 5;
    self.filterBtn = filterBtn;
    [self addSubview:filterBtn];
    [self.btnArray addObject:filterBtn];
    
    @weakify(self);
    for (int i = 0; i < self.btnArray.count; i++) {
        ZGButton *btn = self.btnArray[i];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (sender.tag != 1 && sender.tag == self.selectBtn.tag) return;
            if (sender.tag == 5) {
                [self.styleSub sendNext:@(sender.tag)];
                return;
            }
            self.selectBtn.selected = NO;
            sender.selected = YES;
            self.selectBtn = sender;
            [self.styleSub sendNext:@(sender.tag)];
        }];
    }
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self addSubview:dividerLine];
}

- (void)_setupConstraint {
    ZGButton *tempBtn;
    for (int i = 0; i < self.btnArray.count; i++) {
        ZGButton *btn = self.btnArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tempBtn) {
                make.left.mas_equalTo(tempBtn.mas_right);
                make.width.mas_equalTo(tempBtn);
            } else make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
            if (i == self.btnArray.count-1) make.right.mas_equalTo(self.mas_right);
        }];
        tempBtn = btn;
    }
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.mas_equalTo(self);
    }];
}

@end
