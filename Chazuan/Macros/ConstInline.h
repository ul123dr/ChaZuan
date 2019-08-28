//
//  ConstInline.h
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#ifndef ConstInline_h
#define ConstInline_h

/// 16进制颜色值
/// @param stringToConvert 进制数值
/// @param alp 透明度
CG_INLINE UIColor *kHexColorAlpha(NSString *stringToConvert, float alp) {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alp];
}

/// 16进制颜色值
/// @param stringToConvert 进制数值
CG_INLINE UIColor * kHexColor(NSString *stringToConvert) {
    return kHexColorAlpha(stringToConvert, 1.0);
}

#import "AlertView.h"

/// Alert 快速提示
/// @param message 提示内容
/// @param cancelButtonTitle 取消按钮标题 0
/// @param confirmButtonTitle 确认按钮标题 1
/// @param block 点击回调
CG_INLINE void Alert(NSString * message, NSString * cancelButtonTitle, NSString * confirmButtonTitle, AlertHandle block) {
    if (kStringIsEmpty(message)) {
        message = nil;
    }
    if (kStringIsEmpty(cancelButtonTitle)) {
        cancelButtonTitle = nil;
    }
    if (kStringIsEmpty(confirmButtonTitle)) {
        confirmButtonTitle = nil;
    }
    [AlertView alertWithMessage:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle handle:block];
}

#import "InputAlertView.h"
CG_INLINE void InputAlert(InputAlertHandle handle) {
    [InputAlertView alertWithHandle:handle];
}

/// 打电话功能，这种方式打完电话会回到app
/// @param strPhoneNumber 电话号码
CG_INLINE void callSomeBody(NSString *strPhoneNumber) {
    NSString *mobile = strPhoneNumber;
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]||[deviceType  isEqualToString:@"iPad Simulator"]) {
        Alert(@"您的设备不支持电话功能", @"确定", nil, nil);
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",mobile]] options:@{} completionHandler:nil];
}

CG_INLINE NSString * validateString(id obj) {
    NSString *str=@"";
    if ([obj isKindOfClass:NSNull.class]) {
        
    } else if ([obj isKindOfClass:NSString.class]) {
        str=(NSString*)obj;
        if ([str isEqualToString:@"(null)"]) {
            return @"";
        }
        return str;
    } else if ([obj isKindOfClass:NSNumber.class]) {
        str=[NSString stringWithFormat:@"%@",obj];
        return str;
    }
    return str;
}

CG_INLINE NSString * formatString(id obj) {
    NSString *str = @"";
    if (kObjectIsNil(obj)) {
        return @"-";
    } else if ([obj isKindOfClass:NSString.class]) {
        str = (NSString*)obj;
        if (kStringIsEmpty(str) || [str isEqualToString:@"(null)"]) {
            return @"-";
        }
        return str;
    } else if ([obj isKindOfClass:NSNumber.class]) {
        NSNumber *numObj = (NSNumber*)obj;
        if (numObj.floatValue == 0) return @"-";
        return formatString(numObj.stringValue);
    }
    return str;
}

CG_INLINE NSString * formatWithString(id obj, NSString *formatStr) {
    NSString *str = @"";
    if (kObjectIsNil(obj)) {
        return formatStr;
    } else if ([obj isKindOfClass:NSString.class]) {
        str = (NSString*)obj;
        if (kStringIsEmpty(str) || [str isEqualToString:@"(null)"]) {
            return formatStr;
        }
        return str;
    } else if ([obj isKindOfClass:NSNumber.class]) {
        NSNumber *numObj = (NSNumber*)obj;
        if (!numObj) return formatStr;
        if (numObj.floatValue == 0) return formatStr;
        return formatString(numObj.stringValue);
    }
    return str;
}

/// 辅助方法 创建一个文件夹
static inline void CreateDirectoryAtPath(NSString *path){
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/// 微信重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *WeChatDocDirPath(){
    return [DocumentDirectory stringByAppendingPathComponent:File_DOC_NAME];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *FilePathFromChazuanDoc(NSString *filename){
    NSString *docPath = WeChatDocDirPath();
    CreateDirectoryAtPath(docPath);
    return [docPath stringByAppendingPathComponent:filename];
}

#endif /* ConstInline_h */
