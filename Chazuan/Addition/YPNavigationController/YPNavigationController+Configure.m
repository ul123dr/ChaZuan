//
//  YPNavigationController+Configure.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "YPNavigationController+Configure.h"

@implementation YPNavigationController (Configure)

/* 设定 UIBarStyle 透明情况 背景使用颜色 */
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarStyleBlack | YPNavigationBarBackgroundStyleTranslucent | YPNavigationBarBackgroundStyleNone;
}

/* NavigationBar 的背景色 */
- (UIColor *) yp_navigationBarTintColor {
    return UIColor.whiteColor;
}

@end
