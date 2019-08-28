//
//  Macros.h
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/// MARK: 网络证书有效期至 2019年5月26日

// MARK: - 版本号version
// V1.0  创建查钻初始版本

//#define ServerHttp @"aped.happydiamond.cn" // app主网络域名
// 用户域名
#define ServerHttp @"www.wanttoseeyouagain.com" // www.wanttoseeyouagain.com 123456
//#define ServerHttp @"www.caisezuanshi.com"

/// MARK: - 适配
/// iPhone X 刘海系列判断
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/// 设备宽度
#define kScreenW ([UIScreen mainScreen].bounds.size.width)

/// 设备高度
#define kScreenH ([UIScreen mainScreen].bounds.size.height)

/// 顶部适配
#define kTopSpace (IPHONE_X?44.f:20.f)
//#define kStatusHeight ((![[UIApplication sharedApplication] isStatusBarHidden])?[[UIApplication sharedApplication] statusBarFrame].size.height:(IPHONE_X?44.f:20.f))

/// 设备顶部高度
#define kNavHeight (44.f+kTopSpace)

/// iPhone X 系列底部适配
#define kBottomSpace (IPHONE_X?34.f:0.f)

/// 设备底部高度
#define kBottomHeight (49.f+kBottomSpace)

/*
 4/4S               320*480pt       640*960px       320
 5/5S/5C            320*568pt       640*1136px      320
 6/6S/7/8           375*667pt       750*1334px      375
 6+/6s+/7+/8+       414*736pt       1242*2208px     414
 x/xs               375*812pt       1125*2436px     375
 xsMax              414*896pt       1242*2688px     414
 xr                 414*896pt       828*1792px      414
 */
/// 适配，按屏幕宽度进行适配，岭南以 iPhone6 模板设计
#define ZGCConvertToPx(px) ceil((px) * kScreenW/375.0f)

/// 适配iPhone X + iOS 11
#define ZGCAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

/// 计算文本size
#define sizeOfString(string, font, maxWidth) (string != nil ? [(string) boundingRectWithSize:CGSizeMake((maxWidth), 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeMake(0,0))

/// 设备是否是手机
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 是否5以下设备
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && kScreenH <= 568.0)
/// 是否6以下设备
#define IS_IPHONE_6_OR_LESS (IS_IPHONE && kScreenH <= 667.0)

#define IPHONE_4_7_INFO (kScreenH == 667.0)

#define NetClass(name) Target_##name

/// MARK: - 颜色及字体
/// 统一背景色
#define COLOR_BG kHexColor(@"#F2F2F2")

/// 下划线颜色
#define COLOR_LINE kHexColorAlpha(@"#D9D9D9", 0.5)

/// 主色
#define COLOR_MAIN kHexColor(@"#0E67F4")

/// 普通字体大小，已做适配
#define kFont(size) [UIFont systemFontOfSize:ZGCConvertToPx(size)]

/// 加粗字体大小，已做适配
#define kBoldFont(size) [UIFont boldSystemFontOfSize:ZGCConvertToPx(size)]

/// MARK: - 日志
/// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define ZGCLog(fmt, ...) printf("\n 🏅 [%s] %s [第%d行] [%s] 🏅\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define ZGCLog(fmt, ...)
#endif

/// 注销
#ifdef DEBUG
#define ZGCDealloc printf("\n 🚫 %s(%s) +===+ 销毁了 🚫 \n", [NSStringFromClass([self class]) UTF8String], [self.viewModel.title UTF8String])
#else
#define ZGCDealloc
#endif

#ifdef DEBUG
#define ZGCViewDealloc printf("\n 🚫 %s +===+ 销毁了 🚫 \n", [NSStringFromClass([self class])  UTF8String])
#else
#define ZGCViewDealloc
#endif

#define ZGC_DEPRECATED(o) __attribute((deprecated(o)))

/// MARK: - 函数判断
/// 是否为空对象
#define kObjectIsNil(__object) ((nil == __object) || [__object isKindOfClass:NSNull.class])
#define kObjectIsNotNil(__object) (!kObjectIsNil(__object))

/// 字符串为空
#define kStringIsEmpty(__string) (kObjectIsNil(__string) || (__string.length == 0))

/// 字符串不为空
#define kStringIsNotEmpty(__string) (!kStringIsEmpty(__string))

/// 数组为空
#define kArrayIsEmpty(__array) ((kObjectIsNil(__array)) || (__array.count==0))

// MARK: - 简化调用
/// AppDelegate 简化调用
#define SharedAppDelegate ([AppDelegate shareDelegate])

/// 单例简化调用
#define SingleInstance ([Singleton shareInstance])

/// 根据name获取image
#define ImageNamed(__imageName) [UIImage imageNamed:__imageName]

/// 一些KVO相关定义
#define ZGCNotificationCenter [NSNotificationCenter defaultCenter]

/// AppCaches 文件夹路径
#define CachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
/// App DocumentDirectory 文件夹路径
#define DocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

/// 项目重要数据备份的文件夹名称（Documents/FileDoc）利用NSFileManager来访问
#define File_DOC_NAME  @"FileDoc"

/// 其他常量配置
#import "Constant.h"
#import "ConstInline.h"
#import "ConstEnum.h"
#import "URLConfigure.h"

#endif /* Macros_h */
