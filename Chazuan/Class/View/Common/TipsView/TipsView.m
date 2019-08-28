//
//  TipsView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "TipsView.h"

@interface TipsView()

@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic ,strong) UIImageView *tipImgView;

@property (nonatomic, copy) VoidBlock clickHandle;

@end

@implementation TipsView

- (void)dealloc {
    for (UIGestureRecognizer *gr in self.gestureRecognizers) {
        [self removeGestureRecognizer:gr];
    }
    ZGCViewDealloc;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipImgView];
        
        [self addConstraint];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTipView)];
        [self addGestureRecognizer:tapGR];
    }
    
    return self;
}

+ (instancetype)showWithFrame:(CGRect)rect andMessage:(NSString *)message andImagePath:(NSString *)imgName andHandle:(VoidBlock)handle {
    TipsView *tipV = [[TipsView alloc] initWithFrame:rect];
    if (tipV) {
        tipV.tipLabel.text = message;
        if (imgName) {
            tipV.tipImgView.image = ImageNamed(imgName);
        }
        CGFloat tipHeight = sizeOfString(message, kFont(14), kScreenW).height+5;
        [tipV.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (kStringIsEmpty(imgName))
                make.top.mas_equalTo(tipV).offset(ZGCConvertToPx(10));
            make.height.mas_equalTo(tipHeight);
        }];
        if (handle) {
            tipV.clickHandle = handle;
        }
        [tipV layoutIfNeeded];
    }
    return tipV;
}

- (void)tapTipView {
    if (self.clickHandle) {
        self.clickHandle();
    }
}

- (void)addConstraint {
    [_tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self).offset(kNavHeight+ZGCConvertToPx(80));
        make.width.height.mas_equalTo(ZGCConvertToPx(80));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kNavHeight+ZGCConvertToPx(80)+ZGCConvertToPx(6));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(24));
    }];
}

#pragma mark - Getter
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = kHexColor(@"#1C2B36");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = kFont(14);
    }
    return _tipLabel;
}

- (UIImageView *)tipImgView {
    if (!_tipImgView) {
        _tipImgView = [[UIImageView alloc] init];
    }
    return _tipImgView;
}

@end
