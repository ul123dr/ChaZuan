//
//  AlertView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AlertView.h"

@interface AlertView () <CAAnimationDelegate>

// 灰色背景 background
@property (nonatomic, strong) UIView *shadowView;
// 白色背景（alert页面） whiteBackground
@property (nonatomic, strong) UIView *alertView;
// 模糊化遮盖 fuzzyCover
@property (nonatomic, strong) UIImageView *effectImgView;
// 毛玻璃效果 aeroGlass
@property (nonatomic, strong) UIVisualEffectView *effectView;
// 标题 title
@property (nonatomic, strong) UILabel *titleL;
// 信息 content
@property (nonatomic, strong) UILabel *msgL;
// 水平分隔线
@property (nonatomic, strong) UIView *horizonalLine;
// 取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
// 竖分隔线
@property (nonatomic, strong) UIView *verizonalLine;
// 确定按钮
@property (nonatomic, strong) UIButton *confirmBtn;
// 回调
@property (nonatomic, copy) AlertHandle handle;


@end

@implementation AlertView

- (void)dealloc {
    ZGCViewDealloc;
}

+ (void)alertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle handle:(AlertHandle)handle {
    AlertView *alert = [[AlertView alloc] initWithMessage:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle handle:handle];
    [alert showAnimation];
}

- (instancetype)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle handle:(AlertHandle)handle {
    self = [super init];
    if (self) {
        
        UIWindow *window = SharedAppDelegate.window;
        self.frame = window.bounds;
        [window addSubview:self];
        
        if (handle) {
            _handle = handle;
        }
        
        [self addSubview:self.shadowView];
        [self addSubview:self.alertView];
        
        [self.alertView addSubview:self.effectImgView];
        [self.effectImgView addSubview:self.effectView];
        [self.alertView addSubview:self.titleL];
        [self.alertView addSubview:self.msgL];
        [self.alertView addSubview:self.horizonalLine];
        if (cancelButtonTitle) {
            [self.alertView addSubview:self.cancelBtn];
            [self.cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }
        if (confirmButtonTitle) {
            [self.alertView addSubview:self.confirmBtn];
            [self.confirmBtn setTitle:confirmButtonTitle forState:UIControlStateNormal];
        }
        if (cancelButtonTitle && confirmButtonTitle) {
            [self.alertView addSubview:self.verizonalLine];
        }
        if (!cancelButtonTitle && !confirmButtonTitle) {
            [self.alertView addSubview:self.cancelBtn];
            [self.cancelBtn setTitle:cancelButtonTitle = @"取消" forState:UIControlStateNormal];
        }
        
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        CGSize msgSize = [message boundingRectWithSize:CGSizeMake(230.0f, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        // 使用 attributedText 设置LineSpacing = 0.9 跟系统alert基本一致
        if (message) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            [paragraphStyle setLineSpacing:0.9];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
            [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [message length])];
            self.msgL.attributedText = attrStr;
        }
        //        self.msgL.text = message;
        if (!message || message.length == 0) {
            msgSize = CGSizeZero;
        }
        
        [self addConstraintsWithMsgHeight:msgSize.height];
        
        // 优化底部按钮
        if (!cancelButtonTitle && confirmButtonTitle) {
            [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.horizonalLine.mas_bottom);
                make.left.mas_equalTo(self.alertView);
                make.width.mas_equalTo(self.alertView.mas_width);
                make.bottom.mas_equalTo(self.alertView.mas_bottom);
                make.height.mas_equalTo(44);
            }];
        } else if (cancelButtonTitle && !confirmButtonTitle) {
            [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.horizonalLine.mas_bottom);
                make.left.mas_equalTo(self.alertView);
                make.width.mas_equalTo(self.alertView.mas_width);
                make.bottom.mas_equalTo(self.alertView.mas_bottom);
                make.height.mas_equalTo(44);
            }];
        }
        
        [self.titleL zgc_solveUIWidgetFuzzy];
        [self.msgL zgc_solveUIWidgetFuzzy];
        if (confirmButtonTitle) [self.confirmBtn.titleLabel zgc_solveUIWidgetFuzzy];
        if (cancelButtonTitle) [self.cancelBtn.titleLabel zgc_solveUIWidgetFuzzy];
        
        [self layoutIfNeeded];
        
        [self.titleL setFrame:CGRectIntegral(self.titleL.frame)];
        [self.msgL setFrame:CGRectIntegral(self.msgL.frame)];
    }
    return self;
}

- (void)showAnimation {
    [self.alertView.layer addAnimation:[UIView zgc_zoominAnimation] forKey:ZGCViewAnimationShow];
}

- (void)hideAnimation {
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 0.0f;
        self.alertView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton *)btn {
    if (self.handle) {
        self.handle(btn.tag);
    }
    [self hideAnimation];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 根据上面的标识的key来判断动画
    if ([self.alertView.layer animationForKey:ZGCViewAnimationHide] == anim) {
        [self removeFromSuperview];
    }
}

#pragma mark - Constraint
- (void)addConstraintsWithMsgHeight:(NSUInteger)textHeight {
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(270.0);
    }];
    
    [_effectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.alertView);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.effectImgView);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView).offset(20);
        make.left.mas_equalTo(self.alertView).offset(10);
        make.right.mas_equalTo(self.alertView.mas_right).offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    [_msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertView).offset(41);
        make.left.mas_equalTo(self.alertView).offset(20);
        make.right.mas_equalTo(self.alertView.mas_right).offset(-20);
        make.height.mas_equalTo(textHeight + 3.5);
    }];
    
    [_horizonalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(textHeight ? textHeight + 27.5 : 21);
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizonalLine.mas_bottom);
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView.mas_centerX).offset(-0.25);
        make.bottom.mas_equalTo(self.alertView.mas_bottom);
        make.height.mas_equalTo(42.5);
    }];
    
    [_verizonalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizonalLine.mas_bottom);
        make.bottom.mas_equalTo(self.alertView.mas_bottom);
        make.width.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizonalLine.mas_bottom);
        make.left.mas_equalTo(self.alertView.mas_centerX).offset(0.25);
        make.right.mas_equalTo(self.alertView.mas_right);
        make.bottom.mas_equalTo(self.alertView.mas_bottom);
    }];
}

#pragma mark - Getter
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = kHexColorAlpha(@"#000000", 0.4);
    }
    return _shadowView;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = UIColor.clearColor;
        _alertView.layer.cornerRadius = 13.0f;
        _alertView.layer.masksToBounds = YES;
        _alertView.clipsToBounds = YES;
    }
    return _alertView;
}

- (UIImageView *)effectImgView {
    if (!_effectImgView) {
        _effectImgView = [[UIImageView alloc] init];
        _effectImgView.backgroundColor = UIColor.clearColor;
        _effectImgView.image = [self imageWithColor:kHexColorAlpha(@"#FFFFFF", 0.2)];
    }
    return _effectImgView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleL.text = @"提示";
        _titleL.backgroundColor = UIColor.clearColor;
    }
    return _titleL;
}

- (UILabel *)msgL {
    if (!_msgL) {
        _msgL = [[UILabel alloc] init];
        _msgL.textAlignment = NSTextAlignmentCenter;
        _msgL.font = [UIFont systemFontOfSize:13.0f];
        _msgL.numberOfLines = 0;
        _msgL.backgroundColor = UIColor.clearColor;
    }
    return _msgL;
}

- (UIView *)horizonalLine {
    if (!_horizonalLine) {
        _horizonalLine = [[UIView alloc] init];
        _horizonalLine.backgroundColor = kHexColor(@"#BDBDBD");
    }
    return _horizonalLine;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 0;
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_cancelBtn setTitleColor:kHexColor(@"#027BFF") forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[self imageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[self imageWithColor:kHexColorAlpha(@"#BDBDBD", 0.9)] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = UIColor.clearColor;
    }
    return _cancelBtn;
}

- (UIView *)verizonalLine {
    if (!_verizonalLine) {
        _verizonalLine = [[UIView alloc] init];
        _verizonalLine.backgroundColor = kHexColor(@"#BDBDBD");
    }
    return _verizonalLine;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.tag = 1;
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_confirmBtn setTitleColor:kHexColor(@"#027BFF") forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[self imageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[self imageWithColor:kHexColorAlpha(@"#DBDBDB", 0.9)] forState:UIControlStateHighlighted];
        [_confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.backgroundColor = UIColor.clearColor;
    }
    return _confirmBtn;
}

@end
