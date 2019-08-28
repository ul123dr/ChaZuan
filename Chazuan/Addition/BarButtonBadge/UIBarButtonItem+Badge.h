//
//  UIBarButtonItem+Badge.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Badge)

/// 角标展示label
@property (strong, nonatomic, nullable) UILabel *badge;
/// 角标数值 Badge value to be display
@property (nonatomic, nullable) NSString *badgeValue;
/// 角标背景色 Badge background color
@property (nonatomic) UIColor *badgeBGColor;
/// 文字颜色 Badge text color
@property (nonatomic) UIColor *badgeTextColor;
/// 字体大小 Badge font
@property (nonatomic) UIFont *badgeFont;
/// 边角 Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
/// 最小字体 Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
/// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
/// 数值为0时是否隐藏 In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
/// 值改变动画 Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;
/// 是否展示数值 Badge value hides
@property BOOL shouldHideBadgeValue;


@end

NS_ASSUME_NONNULL_END
