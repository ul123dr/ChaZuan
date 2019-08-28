//
//  AppDelegate.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationControllerStack.h"
#import "ViewModelServicesImpl.h"
#import "ManagerSpecialty.h"
#import "VipDollarRate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readonly, strong) NavigationControllerStack *navigationControllerStack; ///< APP管理的导航栏的堆栈
@property (nonatomic, readonly, strong) ManagerSpecialty *manager;
@property (nonatomic, readonly, strong) VipDollarRate *vipRate;

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)shareDelegate;

/// 跳转登录
- (void)goLoginPage;



@end

