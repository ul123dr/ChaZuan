//
//  MBProgressHUD+ZGExtension.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MBProgressHUD+ZGExtension.h"
#import "UIImage+GIF.h"

@implementation MBProgressHUD (ZGExtension)

/// in window
/// 自定义页面
+ (MBProgressHUD *)zgc_show {
    return [self zgc_showAddedToView:nil];
}

/// 提示信息
+ (MBProgressHUD *)zgc_showTips:(NSString *)tipStr {
    return [self zgc_showTips:tipStr addedToView:nil];
}

/// 提示错误
+ (MBProgressHUD *)zgc_showErrorTips:(NSError *)error {
    return [self zgc_showErrorTips:error addedToView:nil];
}

/// 进度view
+ (MBProgressHUD *)zgc_showProgressHUD:(NSString *)titleStr {
    return [self zgc_showProgressHUD:titleStr addedToView:nil];
}

/// 隐藏hud
+ (void)zgc_hideHUD {
    [self zgc_hideHUDForView:nil];
}

/// 延时隐藏
+ (void)zgc_hideHUDDelay:(NSTimeInterval)time {
    [self zgc_hideHUDForView:nil delay:time];
}


/// in special view
/// 自定义页面
+ (MBProgressHUD *)zgc_showAddedToView:(UIView *)view {
    return [self _showHUDIsAutomaticHide:NO addedToView:view];
}

/// 提示信息
+ (MBProgressHUD *)zgc_showTips:(NSString *)tipStr addedToView:(UIView *)view {
    return [self _showHUDWithTips:tipStr isAutomaticHide:YES addedToView:view];
}

/// 提示错误
+ (MBProgressHUD *)zgc_showErrorTips:(NSError *)error addedToView:(UIView *)view {
    return [self _showHUDWithTips:[self zgc_tipsFromError:error] isAutomaticHide:YES addedToView:view];
}

/// 进度view
+ (MBProgressHUD *)zgc_showProgressHUD:(NSString *)titleStr addedToView:(UIView *)view {
    return [self _showHUDWithTips:titleStr isAutomaticHide:NO addedToView:view];
}

/// 隐藏hud
+ (void)zgc_hideHUDForView:(UIView *)view {
    [self hideHUDForView:[self _willShowingToViewWithSourceView:view] animated:YES];
}

/// 延时隐藏hud
+ (void)zgc_hideHUDForView:(UIView *)view delay:(NSTimeInterval)time {
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:[self _willShowingToViewWithSourceView:view]];
    if (HUD) {
        [HUD hideAnimated:YES afterDelay:time];
    }
}

#pragma mark - 辅助方法
/* 获取将要显示的view */
+ (UIView *)_willShowingToViewWithSourceView:(UIView *)sourceView
{
    if (sourceView) return sourceView;
    
    sourceView = SharedAppDelegate.window;
    if (!sourceView) sourceView = [[[UIApplication sharedApplication] windows] lastObject];
    
    return sourceView;
}

/* 文字HUD */
+ (instancetype)_showHUDWithTips:(NSString *)tipStr isAutomaticHide:(BOOL)isAutomaticHide addedToView:(UIView *)view {
    view = [self _willShowingToViewWithSourceView:view];
    
    // show之前 hid掉之前的
    [self zgc_hideHUDForView:view];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = isAutomaticHide?MBProgressHUDModeText:MBProgressHUDModeIndeterminate;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.label.font = isAutomaticHide?kFont(17.0f):kBoldFont(14.0f);
    HUD.label.textColor = [UIColor whiteColor];
    HUD.contentColor = [UIColor whiteColor];
    HUD.label.text = tipStr;
    HUD.bezelView.layer.cornerRadius = 8.0f;
    HUD.bezelView.layer.masksToBounds = YES;
    HUD.bezelView.color = kHexColorAlpha(@"#000000", .6f);
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.minSize =isAutomaticHide?CGSizeMake([UIScreen mainScreen].bounds.size.width-96.0f, 60):CGSizeMake(120, 120);
    HUD.margin = 18.2f;
    HUD.removeFromSuperViewOnHide = YES;
    if (isAutomaticHide) [HUD hideAnimated:YES afterDelay:1.0f];
    return HUD;
}

/* 自定义图片HUD */
+ (instancetype)_showHUDIsAutomaticHide:(BOOL)isAutomaticHide addedToView:(UIView *)view {
    view = [self _willShowingToViewWithSourceView:view];
    // 先 hide 之前展示的
    [self zgc_hideHUDForView:view];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.bezelView.layer.cornerRadius = 8.0f;
    HUD.bezelView.layer.masksToBounds = YES;
    HUD.backgroundColor = kHexColorAlpha(@"#000000", .4f);
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor clearColor];
    HUD.minSize =isAutomaticHide?CGSizeMake([UIScreen mainScreen].bounds.size.width-96.0f, 60):CGSizeMake(120, 120);
    HUD.margin = 18.2f;
    HUD.removeFromSuperViewOnHide = YES;
    
    
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"loading" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage  *image = [UIImage sd_animatedGIFWithData:imageData];
    UIImageView *gifImageView = [[UIImageView alloc] initWithImage:image];
    gifImageView.layer.cornerRadius = 4;
    gifImageView.layer.masksToBounds = YES;
    gifImageView.backgroundColor = [UIColor clearColor];
    gifImageView.alpha = 0.85;
    gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLayoutConstraint *customViewWidthConstraint = [NSLayoutConstraint constraintWithItem:gifImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50.f];
    NSLayoutConstraint *customViewHeightConstraint = [NSLayoutConstraint constraintWithItem:gifImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50.f];
    [gifImageView addConstraint:customViewWidthConstraint];
    [gifImageView addConstraint:customViewHeightConstraint];
    HUD.customView = gifImageView;
    if (isAutomaticHide) [HUD hideAnimated:YES afterDelay:1.0f];
    
    return HUD;
}

#pragma mark - 辅助属性
+ (NSString *)zgc_tipsFromError:(NSError *)error{
    if (!error) return nil;
    NSString *tipStr = nil;
    // 这里需要处理HTTP请求的错误
    if (error.userInfo[HTTPServiceErrorDescriptionKey]) {
        tipStr = [error.userInfo objectForKey:HTTPServiceErrorDescriptionKey];
    } else if (error.domain) {
        tipStr = error.localizedFailureReason;
    } else {
        tipStr = error.localizedDescription;
    }
    return tipStr;
}

@end
