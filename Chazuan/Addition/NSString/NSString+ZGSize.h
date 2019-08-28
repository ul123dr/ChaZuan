//
//  NSString+ZGSize.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZGSize)

/// 动态计算文字的宽高（单行）
///
/// @param font 文字的字体
/// @return 计算的宽高
- (CGSize)zgc_sizeWithFont:(UIFont *)font;

/// 动态计算文字的宽高（多行）
///
/// @param font 文字的字体
/// @param limitSize 限制的范围
/// @return 计算的宽高
- (CGSize)zgc_sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize;

/// 动态计算文字的宽高（多行）
///
/// @param font 文字的字体
/// @param limitWidth 限制宽度 ，高度不限制
/// @return 计算的宽高
- (CGSize)zgc_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth;


@end

NS_ASSUME_NONNULL_END
