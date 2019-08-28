//
//  SegmentScrollView.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SegmentScrollView.h"
#import "OrderCenterViewModel.h"

@interface SegmentScrollView ()

@property (nonatomic, readwrite, strong) OrderCenterViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIButton *selectBtn;
@property (nonatomic, readwrite, strong) UIView *dividerLine;

@end

@implementation SegmentScrollView

+ (instancetype)segmentScrollView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        UIView *dividerLine = [[UIView alloc] init];
        dividerLine.backgroundColor = COLOR_BG;
        [self addSubview:dividerLine];
        
        [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindViewModel:(OrderCenterViewModel *)viewModel {
    _viewModel = viewModel;
    
    @weakify(self);
    [[RACObserve(viewModel, segmentArr) ignore:nil] subscribeNext:^(NSArray *segmentArr) {
        @strongify(self);
        [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:UIButton.class]) [obj removeFromSuperview];
        }];
        __block CGFloat contentWidth = 0;
        __block UIButton *tempBtn;
        [segmentArr enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn.titleLabel setFont:kFont(14)];
            [btn setTitleColor:kHexColor(@"#1C2B36") forState:UIControlStateNormal];
            [btn setTitleColor:kHexColor(@"#0E67F4") forState:UIControlStateSelected];
            [btn setTitle:title forState:UIControlStateNormal&UIControlStateSelected];
            if (idx == 0) {
                btn.selected = YES;
                self.selectBtn = btn;
                self.viewModel.segmentIndex = idx;
            }
            [self addSubview:btn];
            CGFloat width = sizeOfString(title, kFont(14), ZGCConvertToPx(200)).width;
            contentWidth += (width+ZGCConvertToPx(30));
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.height.mas_equalTo(ZGCConvertToPx(44));
                if (tempBtn) make.left.mas_equalTo(tempBtn.mas_right);
                else make.left.mas_equalTo(self);
                make.width.mas_equalTo(width+ZGCConvertToPx(30));
                if (idx == segmentArr.count-1) make.right.mas_equalTo(self.mas_right);
            }];
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
                @strongify(self);
                if (sender.isSelected) return;
                self.selectBtn.selected = NO;
                sender.selected = YES;
                self.selectBtn = sender;
                self.viewModel.segmentIndex = idx;
                [self _scrollToVisiable:sender];
            }];
            tempBtn = btn;
        }];
    }];
}

- (void)_scrollToVisiable:(UIButton *)btn {
    CGFloat leftX = self.contentOffset.x;
    CGFloat btnOffsetX = btn.center.x - self.bounds.size.width * 0.5 - leftX;
    CGFloat btnWidth = self.contentSize.width - self.bounds.size.width - leftX;
    
    CGPoint contentOffset = CGPointZero;
    if (btnWidth + leftX > 0) {
        if (btnOffsetX > 0 && btnWidth > 0) {
            if (btnOffsetX <= btnWidth)
                contentOffset = CGPointMake(leftX + btnOffsetX, 0);
            else
                contentOffset = CGPointMake(leftX + btnWidth, 0);
            [self setContentOffset:contentOffset animated:YES];
        } else if (btnOffsetX < 0) {
            if (leftX + btnOffsetX < 0)
                contentOffset = CGPointMake(0, 0);
            else
                contentOffset = CGPointMake(leftX + btnOffsetX, 0);
            [self setContentOffset:contentOffset animated:YES];
        }
    }
}

@end
