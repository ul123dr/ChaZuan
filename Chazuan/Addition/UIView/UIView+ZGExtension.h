//
//  UIView+ZGExtension.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZGExtension)

/// 锐化处理，修复模糊
- (void)zgc_solveUIWidgetFuzzy;

/// 放大动画
+ (CAKeyframeAnimation *)zgc_zoominAnimation;

/// 缩小动画
+ (CAKeyframeAnimation *)zgc_zoomoutAnimation;

@end

NS_ASSUME_NONNULL_END
