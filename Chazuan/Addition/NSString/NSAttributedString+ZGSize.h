//
//  NSAttributedString+ZGSize.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZGSize)

/// 动态计算文字的宽高（多行）
///
/// @param limitSize 限制的范围
/// @return 计算的宽高
- (CGSize)zgc_sizeWithLimitSize:(CGSize)limitSize;

/// 动态计算文字的宽高（多行）
///
/// @param limitWidth 限制宽度 ，高度不限制
/// @return 计算的宽高
- (CGSize)zgc_sizeWithLimitWidth:(CGFloat)limitWidth;


@end

NS_ASSUME_NONNULL_END
