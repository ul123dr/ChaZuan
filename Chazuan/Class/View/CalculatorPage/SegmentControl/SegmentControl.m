//
//  SegmentControl.m
//  chazuan
//
//  Created by BecksZ on 2019/4/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SegmentControl.h"

@implementation SegmentViewModel

@end

@interface SegmentControl ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) NSMutableArray *btnArr;
@property (nonatomic, readwrite, strong) ZGButton *selectBtn;
@property (nonatomic, readwrite, assign) NSInteger selectIndex;

@end

@implementation SegmentControl

+ (instancetype)segmentWithItems:(NSArray *)items {
    return [[self alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = items;
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

- (void)bindViewModel:(SegmentViewModel *)viewModel {
    for (int i = 0; i < self.items.count; i++) {
        ZGButton *btn = self.btnArr[i];
        if (viewModel.backColor) [btn setBackgroundImage:[UIImage imageWithColor:viewModel.backColor] forState:UIControlStateNormal];
        if (viewModel.backTintColor) [btn setBackgroundImage:[UIImage imageWithColor:viewModel.backTintColor] forState:UIControlStateSelected];
        if (viewModel.color) [btn setTitleColor:viewModel.color forState:UIControlStateNormal];
        if (viewModel.tintColor) [btn setTitleColor:viewModel.tintColor forState:UIControlStateSelected];
        if (viewModel.font) [btn.titleLabel setFont:viewModel.font];
        [self.btnArr replaceObjectAtIndex:i withObject:btn];
    }
}

#pragma mark - 创建页面
- (void)_setup {
    self.btnArr = [NSMutableArray array];
    self.selectIndex = 1;
}

- (void)_setupSubviews {
    for (int i = 0; i < self.items.count; i++) {
        ZGButton *btn = [ZGButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(15)];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            self.selectBtn = btn;
        }
        [self addSubview:btn];
        [self.btnArr addObject:btn];
        
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (self.selectBtn.tag == sender.tag) return;
            self.selectBtn.selected = NO;
            sender.selected = YES;
            self.selectBtn = sender;
            self.selectIndex = sender.tag+1;
        }];
    }
}

- (void)_setupSubviewsConstraint {
    ZGButton *tempBtn;
    for (int i = 0; i < self.btnArr.count; i++) {
        ZGButton *btn = self.btnArr[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            if (tempBtn) {
                make.left.mas_equalTo(tempBtn.mas_right);
                make.width.mas_equalTo(tempBtn);
            } else make.left.mas_equalTo(self);
            if (i == self.btnArr.count-1) make.right.mas_equalTo(self.mas_right);
        }];
        tempBtn = btn;
    }
}

@end
