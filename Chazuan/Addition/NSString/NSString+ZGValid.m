//
//  NSString+ZGValid.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NSString+ZGValid.h"

@implementation NSString (ZGValid)

/* 检测字符串是否包含中文 */
- (BOOL)zgc_isContainChinese {
    for (int i = 0; i < self.length; i++) {
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff) return YES;
    }
    return NO;
}

/* 有效的手机号码 */
- (BOOL)zgc_isValidMobile {
    NSString *phoneRegex = @"^1[3-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/* 是否移动号码 */
- (BOOL)zgc_isCmMobile {
    NSString *phoneRegex = @"^1(34[0-9]|(3[5-9]|4[78]|5[0-27-9]|78|8[2-478]|9[6-8])\\d)\\d{7}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/* 纯数字 */
- (BOOL)zgc_isPureDigitCharacters  {
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0) return NO;
    return YES;
}

/* 密码 */
- (BOOL)zgc_isPasswordCharacters  {
    NSString *pwdRegex = @"^[a-zA-Z][a-zA-Z0-9_]*$";//@"((?=.*\\d)(?=.*\\D)|(?=.*[a-zA-Z])(?=.*[^a-zA-Z]))^.{8,16}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:self];
}

/* emoji表情 */
- (BOOL)zgc_hasEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

- (NSString *)stringByReplacingEmoji {
    NSString* outString = [self copy];
    
    @autoreleasepool {
        NSRange range;
        NSMutableSet* emojiSet = [NSMutableSet set];
        
        //找出emoji
        for(NSInteger i = 0; i < self.length; i += range.length) {
            range = [self rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *codeString = [self substringWithRange:range];
            
            NSMutableString* hexString = [NSMutableString string];
            for (int i = 0; i < codeString.length; ++i) {
                [hexString appendFormat:@"%02x", [codeString characterAtIndex:i]];
            }
            
            NSScanner* scanner = [NSScanner scannerWithString:hexString];
            UInt64 code = 0x00;
            [scanner scanHexLongLong: &code];
            if (![self isNotEmoji:code]) {
                [emojiSet addObject:codeString];
            }
        }
        //替换emoji
        for (NSString* emojiString in emojiSet) {
            outString = [outString stringByReplacingOccurrencesOfString:emojiString withString:@""];
        }
    }
    return outString;
}

- (BOOL)isNotEmoji:(UInt64) codePoint {
    return (codePoint == 0x0)
    || (codePoint == 0x9)
    || (codePoint == 0xA)
    || (codePoint == 0xD)
    || ((codePoint >= 0x20) && (codePoint <= 0xD7FF))
    || ((codePoint >= 0xFF00) && (codePoint <=
                                  0xFFFF));
}

/* 格式化数字 */
- (NSInteger)zgc_parseInt {
    if (kStringIsEmpty(self)) return 0;
    if (![[self substringToIndex:1] zgc_isPureDigitCharacters]) return 0;
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [self componentsSeparatedByCharactersInSet:nonDigitCharacterSet].firstObject.integerValue;
}

@end
