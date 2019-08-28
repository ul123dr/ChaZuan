//
//  MBProgressHUD+ZGExtension.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ZGExtension)

/// in window
/// 自定义页面
+ (MBProgressHUD *)zgc_show;

/// 提示信息
+ (MBProgressHUD *)zgc_showTips:(NSString *)tipStr;

/// 提示错误
+ (MBProgressHUD *)zgc_showErrorTips:(NSError *)error;

/// 进度view
+ (MBProgressHUD *)zgc_showProgressHUD:(NSString *)titleStr;

/// 隐藏hud
+ (void)zgc_hideHUD;

/// 延时隐藏
+ (void)zgc_hideHUDDelay:(NSTimeInterval)time;



/// in special view
/// 自定义页面
+ (MBProgressHUD *)zgc_showAddedToView:(nullable UIView *)view;

/// 提示信息
+ (MBProgressHUD *)zgc_showTips:(NSString *)tipStr addedToView:(nullable UIView *)view;

/// 提示错误
+ (MBProgressHUD *)zgc_showErrorTips:(NSError *)error addedToView:(nullable UIView *)view;

/// 进度view
+ (MBProgressHUD *)zgc_showProgressHUD:(NSString *)titleStr addedToView:(nullable UIView *)view;

/// 隐藏hud
+ (void)zgc_hideHUDForView:(nullable UIView *)view;

/// 延时隐藏hud
+ (void)zgc_hideHUDForView:(nullable UIView *)view delay:(NSTimeInterval)time;


@end

NS_ASSUME_NONNULL_END
