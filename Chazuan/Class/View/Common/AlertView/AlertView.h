//
//  AlertView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 点击block
typedef void (^AlertHandle)(BOOL action);

/**
 仿系统AlertView，简化版，message，cancel，comfirm
 小遗憾：不能完全像系统alert那样字体清晰，可能和毛玻璃处理有关
 */
@interface AlertView : UIView

/// 创建Alert，根据输入信息，展示Alert页面
/// @param message 提示内容
/// @param cancelButtonTitle cancel按钮标题
/// @param confirmButtonTitle confirm按钮标题
/// @param handle 回调
+ (void)alertWithMessage:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle confirmButtonTitle:(nullable NSString *)confirmButtonTitle handle:(nullable AlertHandle)handle;

@end

NS_ASSUME_NONNULL_END
