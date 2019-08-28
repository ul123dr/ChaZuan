//
//  InputAlertView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "InputAlertView.h"
#import "IQTextView.h"

@interface InputAlertView () <CAAnimationDelegate, UITextViewDelegate>

// 灰色背景 background
@property (nonatomic, strong) UIView *shadowView;
// 白色背景（alert页面） whiteBackground
@property (nonatomic, strong) UIView *alertView;
// 模糊化遮盖 fuzzyCover
@property (nonatomic, strong) UIImageView *effectImgView;
// 毛玻璃效果 aeroGlass
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) IQTextView *textView;
// 水平分隔线
@property (nonatomic, strong) UIView *horizonalLine;
// 取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
// 竖分隔线
@property (nonatomic, strong) UIView *verizonalLine;
// 确定按钮
@property (nonatomic, strong) UIButton *confirmBtn;
// 回调
@property (nonatomic, copy) InputAlertHandle handle;

@end

@implementation InputAlertView

- (void)dealloc {
    ZGCViewDealloc;
}

+ (void)alertWithHandle:(InputAlertHandle)handle {
    InputAlertView *alert = [[InputAlertView alloc] initWithCancelButtonTitle:@"取消" confirmButtonTitle:@"确定" handle:handle];
    [alert showAnimation];
}

- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle handle:(InputAlertHandle)handle {
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
        [self.alertView addSubview:self.textView];
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
        
        [self addConstraints];
        
        if (confirmButtonTitle) [self.confirmBtn.titleLabel zgc_solveUIWidgetFuzzy];
        if (cancelButtonTitle) [self.cancelBtn.titleLabel zgc_solveUIWidgetFuzzy];
        
        [self layoutIfNeeded];
        
        // 添加通知监听见键盘弹出/退出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
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
        self.handle(btn.tag, self.textView.text);
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

// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender {
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    CGFloat keyboardHeight = 0;
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        keyboardHeight = [value CGRectValue].size.height;
    }
    
    [UIView animateWithDuration:[[useInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-keyboardHeight/3.0);
        }];
        [self.alertView.superview layoutIfNeeded];
    }];
}

#pragma mark - Constraint
- (void)addConstraints {
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH);
    }];
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(0);
        make.width.mas_equalTo(270.0);
    }];
    
    [_effectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.alertView);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.effectImgView);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.alertView).offset(10);
        make.right.mas_equalTo(self.alertView.mas_right).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    [_horizonalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizonalLine.mas_bottom);
        make.left.mas_equalTo(self.alertView);
        make.right.mas_equalTo(self.alertView.mas_centerX).offset(-0.25);
        make.bottom.mas_equalTo(self.alertView.mas_bottom);
        make.height.mas_equalTo(44);
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

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.placeholder = @"备注";
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.clipsToBounds = YES;
    }
    return _textView;
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
