//
//  NSString+ZGValid.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZGValid)

/// 检测字符串是否包含中文
- (BOOL)zgc_isContainChinese;

/// 有效的手机号码
- (BOOL)zgc_isValidMobile;

/// 是否移动号码
- (BOOL)zgc_isCmMobile;

/// 纯数字
- (BOOL)zgc_isPureDigitCharacters;

/// 密码
- (BOOL)zgc_isPasswordCharacters;

/// 是否含有emoji表情
- (BOOL)zgc_hasEmoji;

/// 过滤emoji标签
- (NSString *)stringByReplacingEmoji;

/// 格式化数字
- (NSInteger)zgc_parseInt;

@end

NS_ASSUME_NONNULL_END
